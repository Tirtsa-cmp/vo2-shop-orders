public with sharing class StringListTest {
    public static List<String> generateStringList(Integer lengthString) {
        List<String> stringList = new List<String>();
        for(Integer i=0; i<lengthString; i++) {
          stringList.add('Test ' + i);
        }
        return stringList;

    }
}