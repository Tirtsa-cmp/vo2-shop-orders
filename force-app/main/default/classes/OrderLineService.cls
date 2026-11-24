public with sharing class OrderLineService {
    public static void updateOrderLines(List<Order_Line__c> orderLines, Map<Id, Order_Line__c> oldLinesMap) {
        if (orderLines == null || orderLines.isEmpty()) {
            return;
        }

        // 1. Collecter les IDs de produits référencés (hors boucle SOQL)
        Set<Id> productIds = new Set<Id>();
        for (Order_Line__c line : orderLines) {
            if (line.Product__c != null) {
                productIds.add(line.Product__c);
            }
        }

        // 2. Charger les produits en une seule requête SOQL
        Map<Id, Product__c> productsById = new Map<Id, Product__c>();
        if (!productIds.isEmpty()) {
            productsById = new Map<Id, Product__c>([
                SELECT Id, Unit_Price__c
                FROM Product__c
                WHERE Id IN :productIds
            ]);
        }

        // 3. Appliquer la règle R1 sur chaque ligne
        for (Order_Line__c line : orderLines) {
            Boolean productChanged = oldLinesMap != null
                && line.Id != null
                && oldLinesMap.containsKey(line.Id)
                && oldLinesMap.get(line.Id).Product__c != line.Product__c;

            Boolean hasProductPrice = line.Product__c != null
                && productsById.containsKey(line.Product__c)
                && productsById.get(line.Product__c).Unit_Price__c != null;

            if (hasProductPrice && (line.Unit_Price__c == null || productChanged)) {
                line.Unit_Price__c = productsById.get(line.Product__c).Unit_Price__c;
            }

            if (line.Unit_Price__c != null && line.Quantity__c != null) {
                line.Line_Total__c = line.Unit_Price__c * line.Quantity__c;
            } else {
                line.Line_Total__c = 0;
            }
        }
    }

    public static void DmlChangeOrderLine(List<Order_Line__c> newLines, Map<Id, Order_Line__c> oldLinesMap) {
        Set<Id> orderIds = new Set<Id>();
        if (newLines != null) {
            for (Order_Line__c line : newLines) {
                if (line.Order__c != null) {
                    orderIds.add(line.Order__c);
                }
            }
        }
        if (oldLinesMap != null) {
            for (Order_Line__c oldLine : oldLinesMap.values()) {
                if (oldLine.Order__c != null) {
                    orderIds.add(oldLine.Order__c);
                }
            }
        }
        if (orderIds.isEmpty()) {
            return;
        }

        // Initialiser chaque commande à 0 (utile si toutes ses lignes ont été supprimées ou déplacées)
        Map<Id, Decimal> totalsByOrderId = new Map<Id, Decimal>();
        for (Id orderId : orderIds) {
            totalsByOrderId.put(orderId, 0);
        }

        // Une seule requête agrégée sur Order_Line__c
        for (AggregateResult ar : [
            SELECT Order__c orderId, SUM(Line_Total__c) totalAmount
            FROM Order_Line__c
            WHERE Order__c IN :orderIds
            GROUP BY Order__c
        ]) {
            Id orderId = (Id) ar.get('orderId');
            Decimal totalAmount = (Decimal) ar.get('totalAmount');
            totalsByOrderId.put(orderId, totalAmount != null ? totalAmount : 0);
        }

        // Un seul update sur les commandes concernées
        List<Order__c> ordersToUpdate = new List<Order__c>();
        for (Id orderId : orderIds) {
            ordersToUpdate.add(new Order__c(
                Id = orderId,
                Total_Amount__c = totalsByOrderId.get(orderId)
            ));
        }
        update ordersToUpdate;
    }

    public static void orderIsDraft(List<Order_Line__c> newLines, Map<Id, Order_Line__c> oldLinesMap) {
        Set<Id> orderIds = new Set<Id>();

        if (newLines != null) {
            for (Order_Line__c line : newLines) {
                if (line.Order__c != null) {
                    orderIds.add(line.Order__c);
                }
            }
        }

        if (oldLinesMap != null) {
            for (Order_Line__c oldLine : oldLinesMap.values()) {
                if (oldLine.Order__c != null) {
                    orderIds.add(oldLine.Order__c);
                }
            }
        }

        if (orderIds.isEmpty()) {
            return;
        }

        Map<Id, Order__c> nonDraftOrders = new Map<Id, Order__c>([
            SELECT Id, Status__c
            FROM Order__c
            WHERE Id IN :orderIds
            AND Status__c != 'Draft'
        ]);

        if (nonDraftOrders.isEmpty()) {
            return;
        }

        Set<Id> nonDraftOrderIds = nonDraftOrders.keySet();

        // Cas update (newLines != null)
        if (newLines != null) {
            for (Order_Line__c line : newLines) {
                Boolean currentOrderLocked = line.Order__c != null && nonDraftOrderIds.contains(line.Order__c);
                Boolean previousOrderLocked = false;

                if (oldLinesMap != null && line.Id != null && oldLinesMap.containsKey(line.Id)) {
                    Id oldOrderId = oldLinesMap.get(line.Id).Order__c;
                    previousOrderLocked = oldOrderId != null && nonDraftOrderIds.contains(oldOrderId);
                }

                if (currentOrderLocked || previousOrderLocked) {
                    line.addError('Impossible de modifier une ligne lorsque la commande n\'est pas au statut Draft.');
                }
            }
        }

        // Cas delete (newLines == null)
        if (newLines == null && oldLinesMap != null) {
            for (Order_Line__c oldLine : oldLinesMap.values()) {
                if (oldLine.Order__c != null && nonDraftOrderIds.contains(oldLine.Order__c)) {
                    oldLine.addError('Impossible de supprimer une ligne lorsque la commande n\'est pas au statut Draft.');
                }
            }
        }
    }
}
