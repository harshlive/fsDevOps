({
    getEvents : function(component,renderCalendar) {
        //show spinner
        var action = component.get("c.getEvents");
        action.setParams({
            "selectedUser" : component.get("v.selectedUser") 
        });
        var self = this;
        action.setCallback(this, function(response){
            component.set("v.events", response.getReturnValue());
            if(renderCalendar == 'RENDER_CALENDAR'){
                self.rerenderCalendar(component);
            }
        });
        $A.enqueueAction(action);
    },
    getNewEvent : function(component) {
        var action = component.get("c.getNewEvent");
        var self = this;
        action.setCallback(this, function(response){
            component.set("v.event", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    updateNewEvent : function(component, eventId, eventStart, eventEnd, callback) {
        if(!eventEnd){
            eventEnd = eventStart;
        }
        var action = component.get("c.updateEvent");
        action.setParams({ 
            "eventId": eventId,
            "startDateTime": eventStart.format('MM/DD/YYYY hh:mm A'),
            "endDateTime": eventEnd.format('MM/DD/YYYY hh:mm A')
        });
        if (callback) {
            action.setCallback(this, callback);
        }
        $A.enqueueAction(action);
    },
    renderCalendar : function(component, event) {
        var self = this;
        var v = event.getParam("value");
        if (v === component.get("v.events")) {
            var timeZone = component.get('v.userTimeZone');
            var eventsArray = component.get("v.events");
            var textColor = component.get("v.textColor");
            var theme = component.get("v.theme");
            var bgColor = component.get("v.eventBackgroundColor");
            var borderColor = component.get("v.eventBorderColor");
            $(document).ready(function(){
                calendarEvents = [];
                $.each(eventsArray, function(index, value){
                    newEvent = {
                        id: this.Id,
                        title: this.Name ,
                        start: moment.tz(this.Planned_Start__c,timeZone),
                        tasks: this.Tasks__r,
                        end: moment.tz(this.Planned_End__c,timeZone),
                        className: theme,
                        allDay: false
                    }
                    var isAfter = moment(this.Planned_Start__c).isAfter(new Date().toISOString());
                    if(isAfter === true) {
                        //blue
                        newEvent.backgroundColor = '#3a87ad';
                        newEvent.borderColor = '#3a87ad';
                        newEvent.textColor = 'white';
                    }
                    else 
                    {
                        if(this.Status__c === 'Completed'){
                            newEvent.backgroundColor = '#cfc';
                            newEvent.borderColor = 'green';
                            newEvent.textColor = 'black';
                            
                        }
                        else{
                            newEvent.backgroundColor = 'red';
                            newEvent.borderColor = 'black';
                            newEvent.textColor = 'white';
                        }
                        
                    }
                    
                    if (newEvent.start != undefined && newEvent.end != undefined) {
                        calendarEvents.push(newEvent);
                    }
                });
                $('#calendar').fullCalendar({
                    header: {
                        left: 'today prev,next',
                        center: 'title',
                        right: 'agendaDay,agendaWeek,month'
                    },
                    editable: true,
                    droppable: true,
                    eventLimit: true,
                    eventTextColor: textColor,
                    selectable: true,
                    events: calendarEvents,
                    nextDayThreshold:'00:00:00',
                    dayClick: function(date, jsEvent, view) {
                    },
                    eventDrop: function(event, delta, revertFunc) {
                        console.log(event);
                        self.updateNewEvent(component, event.id, event.start, event.end, function(a) {
                        });
                    },
                    eventResize: function(event, delta, revertFunc) {
                        self.updateNewEvent(component, event.id, event.start, event.end, function(a) {
                        });
                    },
                    eventClick: function(calEvent, jsEvent, view) {
                        $('#editModal').find('#editTitle').val(calEvent.title);
                        $('#editModal').find('#editStartDate').val(calEvent.start.format('YYYY-MM-DD'));
                        $('#editModal').find('#editStartTime').val(calEvent.start.format('HH:mm'));
                        if(calEvent!=null && calEvent.end !=null){
                            $('#editModal').find('#editEndDate').val(calEvent.end.format('YYYY-MM-DD'));
                            $('#editModal').find('#editEndTime').val(calEvent.end.format('HH:mm'));
                        }else{
                            $('#editModal').find('#editEndDate').val(calEvent.start.format('YYYY-MM-DD'));
                            $('#editModal').find('#editEndTime').val(calEvent.start.format('HH:mm'));
                        }
                        if(calEvent.tasks && calEvent.tasks.length >0){
                            for(var i=0;i<calEvent.tasks.length;i++){
                                $('#editModal').find('#'+calEvent.tasks[i].Survey__c).prop('checked', true);
                            }
                        }
                        $('#editButton').data('id', calEvent.id);
                        $('#editButton').data('record', calEvent);
                        $('#editModal').addClass('slds-fade-in-open');
                        $('#backdrop').addClass('slds-backdrop--open');
                        
                    },
                    drop: function(event, delta, revertFunc) {
                        return new Promise($A.getCallback(function(resolve, reject) {
                            component.set("v.showSpinner",true);
                            var newEvent = {
                                OwnerId: component.get("v.selectedUser"),
                                accountId: component.get("v.draggedEventId"),
                                Subject: component.get("v.draggedEventAccountName"),
                                StartDateTime: event.format('MM/DD/YYYY hh:mm A',timeZone),
                                EndDateTime: event.format('MM/DD/YYYY hh:mm A',timeZone)
                            };
                            self.saveEvent(component,newEvent,function(a){
                                var events = component.get("v.events");
                                if(a.getReturnValue().inContainmentZone == true) {
                                    //alert('inContainmentZone');
                                    component.set('v.isAlertModalOpen',true);
                                }
                                events.push(a.getReturnValue().visitRec);
                                component.set("v.events",events);
                                console.log('saveEvent return back');
                                self.rerenderCalendar(component);
                            });
                        }));
                    }
                });
            });
        }
    },
    saveEventWithSurveys : function(component, newEvent, callback) {
        var action = component.get("c.saveNewEventWithSurveys");
        action.setParams({ 
            "ownerId": newEvent.OwnerId,
            "subject": newEvent.Subject,
            "startDateTime": newEvent.StartDateTime,
            "endDateTime": newEvent.EndDateTime,
            "accountId" : newEvent.accountId,
            ///////////////////
            /////////////////////
            "selectedSurveys" : newEvent.selectedSurveys.toString()
        });
        if (callback) {
            action.setCallback(this, callback);
        }
        $A.enqueueAction(action);
    },
    saveEvent : function(component, newEvent, callback) {
        console.log('saveEvent return back1');
        var action = component.get("c.saveNewEvent");
        action.setParams({ 
            "ownerId": newEvent.OwnerId,
            "subject": newEvent.Subject,
            "startDateTime": newEvent.StartDateTime,
            "endDateTime": newEvent.EndDateTime,
            //////////////
            //////////////
            "accountId" : newEvent.accountId
        });
        if (callback) {
            action.setCallback(this, callback);
        }
        $A.enqueueAction(action);
    },
    updateOldEvent : function(component,allEvents, oldEvent, callback) {
        var action = component.get("c.updateOlderEvent");
        action.setParams({ 
            "eventId": oldEvent.eventId,
            "subject": oldEvent.Subject,
            "startDateTime": oldEvent.StartDateTime,
            "endDateTime": oldEvent.EndDateTime,
            "selectedSurveys" : oldEvent.selectedSurveys.toString(),
            "allEvents" : JSON.stringify(allEvents)
        });
        if (callback) {
            action.setCallback(this, callback);
        }
        $A.enqueueAction(action);
    },
    rerenderCalendar : function(component) {
        var timeZone = component.get('v.userTimeZone');
        var eventsArray = component.get("v.events");
        var theme = component.get("v.theme");
        var bgColor = component.get("v.eventBackgroundColor");
        var borderColor = component.get("v.eventBorderColor");
        calendarEvents = [];
        $.each(eventsArray, function(index, value){
            console.log(this);
            
            newEvent = {
                start: moment.tz(this.Planned_Start__c,timeZone),
                end: moment.tz(this.Planned_End__c,timeZone),
                id: this.Id,
                title: this.Name ,
                tasks: this.Tasks__r,
                className: theme,
                allDay: false
            }
            var isAfter = moment(this.Planned_Start__c).isAfter(new Date().toISOString());
            if(isAfter === true) {
                //blue
                newEvent.backgroundColor = '#3a87ad';
                newEvent.borderColor = '#3a87ad';
                newEvent.textColor = 'white';
            }
            else 
            {
                if(this.Status__c === 'Completed'){
                    newEvent.backgroundColor = '#cfc';
                    newEvent.borderColor = 'green';
                    newEvent.textColor = 'black';
                    
                }
                else{
                    newEvent.backgroundColor = 'red';
                    newEvent.borderColor = 'black';
                    newEvent.textColor = 'white';
                }
            }
            
            
            if (newEvent.start != undefined && newEvent.end != undefined) {
                calendarEvents.push(newEvent);
            }
        });  
        console.log('Add data fetched '+calendarEvents);
        $('#calendar').fullCalendar('removeEvents');
        $('#calendar').fullCalendar('addEventSource', calendarEvents);
        console.log('Fullcalendar rerendered');
        $('#viewModal').removeClass('slds-fade-in-open');
        $('#backdrop').removeClass('slds-backdrop--open');
        component.set("v.showSpinner",false);
    },
    deleteOldEvent : function(component, oldEvent, callback) {
        var action = component.get("c.deleteEvent");
        action.setParams({ 
            "eventId": oldEvent.id
        });
        if (callback) {
            action.setCallback(this, callback);
        }
        $A.enqueueAction(action);
    },
    getAccounts : function(component,searchText,selectedType){
        var action = component.get("c.getAllAccounts");
        action.setParams({ 
            searchText : searchText,
            selectedType : selectedType
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.allAccounts",response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    getLead :function(component,searchText){
        // component.set("v.showAccount",false);
        var action = component.get("c.getAllLead");
        action.setParams({ 
            searchText : searchText,
            // selectedType : selectedType
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.allLeads",response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    /* getObject: function(component){
    },*/
    getGrades : function(component){
        var action = component.get("c.getGrades");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.gradeOptions",response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    getUsers : function(component){
        var self = this;
        var action = component.get("c.getUsersFromDb");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.userOptions",response.getReturnValue());
                component.set("v.selectedUser",response.getReturnValue()[0].Id);
                self.getEvents(component,'');
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    getSurveys : function(component){
        var self = this;
        var action = component.get("c.getAllSurveys");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.surveys",response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    
                }
        });
        $A.enqueueAction(action);
    },
    getTimeZone : function(component){
        var self = this;
        var action = component.get("c.getLoggedInUserTimeZone");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.userTimeZone",response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
})