public with sharing class SignatureHelper {
      
    @AuraEnabled
    public static void saveSign(String strSignElement,string orderid){
        system.debug('strSignElement'+strSignElement);
              order o=new order(id=orderid);
              system.debug('orderid'+orderid);
  //  Contact con = new Contact(Id='0032v00002ypAntAAE');
            Attachment objAttachment = new Attachment();
            objAttachment.Name = 'Demo-Signature.png';
            objAttachment.ParentId = o.Id;
            objAttachment.ContentType = 'image/png';
            objAttachment.Body = EncodingUtil.base64Decode(strSignElement);        
            insert objAttachment;
            //return objAttachment;   
         
                   
    }
           
           //   System.debug('called');
       // System.debug(content);      
        //ContentVersion cv = new ContentVersion();
       // cv.ContentLocation = 'S';
        //cv.VersionData = EncodingUtil.base64Decode(strSignElement);
       // cv.Title = 'Demo-Signature.png';
        //cv.PathOnClient = 'Signature.png';
        //insert cv;
        //ContentDocumentLink cdl = new ContentDocumentLink();
        //cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        //cdl.LinkedEntityId = parentId;
       // cdl.ShareType = 'V';
        //insert cdl;
        //stage = 1;    
   // }
}