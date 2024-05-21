public class AddressService {

/*
*  Creates a validation xml request for an entered address.
*/
  public class AddressValidationRequest {

    public UserDetails userDetails {get;set;}
    public Address address {get;set;}

    public AddressValidationRequest(Account account) {
      userDetails = new UserDetails();
      address = new Address(account);
    }

    public String toXml() {

      // Create our top level doc and request node
      Dom.Document requestDoc = createXMLRequestDocument();
      Dom.XmlNode bodyNode = requestDoc.getRootElement().addChildElement('soapenv:Body', null, null);
      Dom.XmlNode requestMessageNode = bodyNode.addChildElement('addressValidationRequest', null, null);

      // Add user details
      Dom.XmlNode userDetailsNode = requestMessageNode.addChildElement('userDetails', null, null);
      userDetails.addToXmlDoc(userDetailsNode);

      // Add address
      Dom.XmlNode addressNode = requestMessageNode.addChildElement('address', null, null);
      address.addToXmlDoc(addressNode);

      return requestDoc.toXMLString();
    }
  }

  public class UserDetails {

    public String username {get;set;}
    public String accessToken {get;set;}

    public UserDetails() {
      // In an actual app these would probably come from a custom setting
      username = 'me@company.com';
      accessToken = 'kjhgjkshfgfkjdfhg';
    }

    public void addToXmlDoc(Dom.XmlNode parentNode) {
      parentNode.addChildElement('username', null, null)
        .addTextNode(username);
    }
  }

  public class Address {

    public String streetAddress {get;set;}
    public String conurbation {get;set;}
    // ... other address vars

    public Address(Account acct) {
      this.streetAddress = acc.ShippingStreet;
      this.conurbation = acc.ShippingCity;
      // ... set other address vars
    }

    public void addToXmlDoc(Dom.XmlNode parentNode) {
      parentNode.addChildElement('streetAddress', null, null)
        .addTextNode(streetAddress);
      parentNode.addChildElement('conurbation', null, null)
        .addTextNode(conurbation);
      // ... add other vars
    }

    public static String fetchNotes(String serviceEntity, String memberOrUniqueId, String selectedSystem){
        return JSON.serialize(CSCalloutUtil.getNotes(serviceEntity,memberOrUniqueId));
    } 

    public static void insertAttachment(String recordId, String commentList){
        String textContent = '';
        List<CSCalloutController.NoteData> notes = (List<CSCalloutController.NoteData>) JSON.deserialize(commentList, List<CSCalloutController.NoteData>.class);
        for (CSCalloutController.NoteData note : notes) {
            //textContent += 'Id: '+note.id + '\n';
            textContent += 'Alert: '+note.alert + '\n';
            textContent += 'Note Type: '+note.noteType + '\n';
            textContent += 'Note Sub Type: '+note.noteSubType + '\n';
            textContent += 'Comments: '+note.comments + '\n';
            textContent += 'Comment By: '+note.commentBy + '\n';
            textContent += 'Comment Date: '+note.commentDate + '\n';
            textContent += 'Comment Time: '+note.commentTime + '\n\n';
        }
        Attachment attachment = new Attachment();
        attachment.ParentId = recordId; // Attach to the specified record
        attachment.Name = 'NotesComments.txt'; // Name of the attachment
        attachment.Body = Blob.valueOf(textContent); // Convert the content to Blob

        insert attachment;
    }

    public static String fetchContractDetails(String serviceEntity, String memberOrUniqueId, String contractId){
        System.debug('serviceEntity, memberOrUniqueId ' + serviceEntity + '  '  + memberOrUniqueId);
        return JSON.serialize(CSCalloutUtil.getOwnershipOrContract(serviceEntity, memberOrUniqueId,''));
    }

    public static void updateTotalPoints(String recordId, String points){
        update new Case(Id = recordId, CSTotal_points_credits__c = String.valueOf(Integer.valueOf(points) * 40));
    }
  }
}