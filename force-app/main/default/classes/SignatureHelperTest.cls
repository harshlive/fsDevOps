@isTest 
private class SignatureHelperTest {
    
    @isTest static void saveSignTest() {
        Account act = new Account(name='test act');
        insert act;
        Order ord = new Order(EffectiveDate=system.today(), Status='Draft');
        ord.AccountId = act.id;
        insert ord;
        SignatureHelper.saveSign( 'iVBORw0KGgoAAAANSUhE' ,ord.id ); 
    }
    
}