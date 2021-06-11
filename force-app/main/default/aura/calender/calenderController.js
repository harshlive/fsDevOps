({
    doInit : function(component, event, helper) {
        //var calendarEvents=[];
        console.log('doinit');
        helper.getTimeZone(component);
      //  helper.getObject(component);
       // helper.getGrades(component);
        helper.getUsers(component);
        helper.getSurveys(component);
      //  helper.getAccounts(component,'','');
      helper.getLead(component,'');
        helper.getNewEvent(component);
        var pathname = window.location.pathname.split('/');
        var sPrefix = '/resource/RG_CalendarAssets/RG_CalendarAssets/assets/icons/action-sprite/svg/symbols.svg#close';
        if (pathname[1] != 'c') {
            sPrefix = '/' + pathname[1] + '/resource/RG_CalendarAssets/RG_CalendarAssets/assets/icons/action-sprite/svg/symbols.svg#close';
        }
        $('.slds-modal__close svg use').attr('xlink:href', sPrefix);
    },
    
    
   
 //  onChangeView : function(c,e,h){
       // var id = e.currentTarget.id;
       
        //var selectedValue=c.find("distance").get("v.value");
//console.log('selectedValue',selectedValue);
      //  if(selectedValue === "1"){
      
    onChangeView : function(c,e,h){
        var id = e.currentTarget.id;
        if(id == 'mapBtn'){
            c.set("v.selectedView", "Map View");
            setTimeout(function(){
                try{
                    document.getElementById('mapViewContainer').innerHTML = "<div id='map' style='width: 100%; height: 100%;'></div>";
                    var map = L.map('map', {zoomControl: true, tap: false})
                    .setView([17.3850, 78.4867], 14);
                    L.tileLayer(
                        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
                        {
                            attribution: 'Tiles © Esri'
                        }).addTo(map);
                    var markerArray = [];
                    var allLeads = c.get('v.allLeads');
                    for(var i=0;i<allLeads.length;i++){
                        var lead = allLeads[i];
                        if(lead.Address_Geolocatopon__Latitude__s != null && lead.Address_Geolocatopon__Longitude__s != null){
                            var marker = new L.Marker([lead.Address_Geolocatopon__Latitude__s,lead.Address_Geolocatopon__Longitude__s],{leadId : lead.Id,leadName:lead.Name})
                            .on('click',function(e){
                                
                            }).on('mouseover',function(ev) {
                                try{
                                    var popup = L.popup()
                                    .setLatLng(e.latlng) 
                                    .setContent('Popup')
                                    .openOn(map);
                                }catch(e){
                                    
                                }
                            }).on('mouseout', function (e) {
                                marker.closePopup();
                            }).on('dblclick', function(event){
                                $('#viewModal').find('#newTitle').val(this.options.leadName);
                                $('#viewModal').find('#newStartDate').val(moment(new Date()).format('YYYY-MM-DD'));
                                $('#viewModal').find('#newStartTime').val(moment(new Date()).format('HH:mm'));
                                $('#viewModal').find('#newEndDate').val(moment(new Date()).format('YYYY-MM-DD'));
                                $('#viewModal').find('#newEndTime').val(moment(new Date()).format('HH:mm'));
                                $('#newEventButton').data('leadId', this.options.leadId);
                                $('#viewModal').addClass('slds-fade-in-open');
                                $('#backdrop').addClass('slds-backdrop--open');
                            }).bindPopup('<h1 style="font-weight:bold;font-size:18px;">'+lead.Name+'</h1>');
                            markerArray.push(marker);
                        }
                    }
                    var group = L.featureGroup(markerArray).addTo(map);
                    map.fitBounds(group.getBounds());
                    c.set("v.map", map);
                }catch(e){
                    
                }
            },2000);
        }else if(id == 'calBtn'){
            c.set("v.selectedView", "Calendar View");
        }
    },
    
 
    onHoverExternalEvent : function(component,event,helper){
        $('#external-events .fc-event').each(function() {
            $(this).data('event', {
                title: $.trim($(this).attr('data-leadName')),
                stick: true
            });
            $(this).draggable({
                start: function() {
                    var divContext = $(this);
                    component.set("v.draggedEventId",divContext.attr('id'));
                    component.set("v.draggedEventAccountName", divContext.attr('data-leadName'));
                    console.log('leadname',component.get("v.draggedEventAccountName"));
                    console.log('leadid',component.get("v.draggedEventId"));
                },
                drag: function() {
                    
                },
                stop: function() {
                    
                },
                zIndex: 999,
                revert: true, 
                revertDuration: 0 
            });    
            
        });  
    },
    eventsChange : function(component, event, helper) {
        helper.renderCalendar(component, event);
    },
    closeViewModal : function(component, modalId) {
        $('#viewModal').removeClass('slds-fade-in-open');
        $('#backdrop').removeClass('slds-backdrop--open');
    },
    closeEditModal : function(component, modalId) {
        $.each($('fieldset.slds-form--compound').find('input'), function(index,value){
            $(this).val('');
        });
        var checkboxes = $('.survey-edit-checkbox');
        for(var i=0;i<checkboxes.length;i++){
            checkboxes[i].checked = false;
        }
        $('fieldset.slds-form--compound').find('textarea').val('');
        $('#editModal').removeClass('slds-fade-in-open');
        $('#backdrop').removeClass('slds-backdrop--open');
    },
    formatEvent : function(component, event, helper) {
        var newEvent = component.get('v.event');
        var eventStartDate = $('#viewModal').find('#newStartDate').val();
        var eventEndDate = $('#viewModal').find('#newEndDate').val();
        var eventStartDateTime = eventStartDate + ' ' + $('#viewModal').find('#newStartTime').val();
        var eventEndDateTime = eventEndDate + ' ' + $('#viewModal').find('#newEndTime').val(); 
        newEvent.StartDateTime = moment(eventStartDateTime, "YYYY-MM-DD HH:mm").format('MM/DD/YYYY hh:mm A');
        newEvent.EndDateTime = moment(eventEndDateTime, "YYYY-MM-DD HH:mm").format('MM/DD/YYYY hh:mm A');
        newEvent.leadId = $('#newEventButton').data('leadId');
        newEvent.Subject = $('#viewModal').find('#newTitle').val();
        newEvent.OwnerId = component.get('v.selectedUser');
        var checkboxes = $('.survey-new-checkbox');
        var selectedSurveys = [];
        for(var i=0;i<checkboxes.length;i++){
            if(checkboxes[i].checked){
                selectedSurveys.push(checkboxes[i].value.split('~')[1]);
            }
        }
        newEvent.selectedSurveys = selectedSurveys;
        // Save Event
        helper.saveEventWithSurveys(component, newEvent, function(a) {
            $("#viewModal").find('newStartDate').val('');
            $("#viewModal").find('newEndDate').val('');
            $("#viewModal").find('newStartTime').val('');
            $("#viewModal").find('newEndTime').val('');
            $("#viewModal").find('newTitle').val('');
            var checkboxes = $('.survey-new-checkbox');
            for(var i=0;i<checkboxes.length;i++){
                checkboxes[i].checked = false;
            }
            var events = component.get("v.events");
            events.push(a.getReturnValue());
            component.set("v.events", events);
            this.rerenderCalendar(component);
        });
    },
    editEvent : function(component, event, helper) {
        var newEvent = {
            eventId : $('#editButton').data('id'),
            Subject : $('#editModal').find('#editTitle').val()
        };
        var oldEvent = $('#editButton').data('record');
        var eventStartDate = $('#editModal').find('#editStartDate').val();
        var eventEndDate = $('#editModal').find('#editEndDate').val();
        var eventStartDateTime = eventStartDate + ' ' + $('#editModal').find('#editStartTime').val();
        var eventEndDateTime = eventEndDate + ' ' + $('#editModal').find('#editEndTime').val(); 
        newEvent.StartDateTime = moment(eventStartDateTime, "YYYY-MM-DD HH:mm").format('MM/DD/YYYY hh:mm a');
        newEvent.EndDateTime = moment(eventEndDateTime, "YYYY-MM-DD HH:mm").format('MM/DD/YYYY hh:mm a');
        var checkboxes = $('.survey-edit-checkbox');
        var selectedSurveys = [];
        for(var i=0;i<checkboxes.length;i++){
            if(checkboxes[i].checked){
                selectedSurveys.push(checkboxes[i].value);
            }
        }
        newEvent.selectedSurveys = selectedSurveys;
        helper.updateOldEvent(component, component.get('v.events'), newEvent, function(a) {
            var theme = component.get("v.theme");
            var bgColor = component.get("v.eventBackgroundColor");
            var borderColor = component.get("v.eventBorderColor");
            $.each($('fieldset.slds-form--compound').find('input'), function(index,value){
                $(this).val('');
            });
            var checkboxes = $('.survey-edit-checkbox');
            for(var i=0;i<checkboxes.length;i++){
                checkboxes[i].checked = false;
            }
            $('fieldset.slds-form--compound').find('textarea').val('');
            var returnedEvent = a.getReturnValue();
            var newEventsList = [];
            var eventsList = component.get('v.events');
            for(var j=0;j<eventsList.length;j++){
                var event = eventsList[j];
                if(event.Id == returnedEvent.Id){
                    newEventsList.push(returnedEvent);
                }else{
                    newEventsList.push(event);
                }
            }
            component.set('v.events',newEventsList);
            helper.rerenderCalendar(component);
            $('#editModal').removeClass('slds-fade-in-open');
            $('#backdrop').removeClass('slds-backdrop--open');
        });
    },
    deleteOldEvent : function(component, event, helper) {
        var oldEvent = $('#editButton').data('record');
        helper.deleteOldEvent(component, oldEvent, function(a) {
            $('#editModal').removeClass('slds-fade-in-open');
            $('#backdrop').removeClass('slds-backdrop--open');
            $('#calendar').fullCalendar('removeEvents',oldEvent.id);
            var newEventsList = [];
            var eventsList = component.get('v.events');
            for(var j=0;j<eventsList.length;j++){
                var event = eventsList[j];
                if(event.Id != oldEvent.id){
                    newEventsList.push(event);
                }
            }
            component.set('v.events',newEventsList);
        });
    },
    onChangeAccountSearch : function(c,e,h){
           h.getLead(c,c.get('v.searchAccountText'));  
       
    },
 
    onChangeRepresentative : function(c,e,h){
        h.getEvents(c,'RENDER_CALENDAR'); 
    }
})