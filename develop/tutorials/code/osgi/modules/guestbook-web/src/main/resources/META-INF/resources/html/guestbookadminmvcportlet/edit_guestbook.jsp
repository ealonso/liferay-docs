<%@include file = "../init.jsp" %>

<%
        Guestbook guestbook = null;

        String redirect = ParamUtil.getString(request, "redirect");

        long guestbookId = ParamUtil.getLong(request, "guestbookId");

        if (guestbookId > 0) {
                guestbook = GuestbookLocalServiceUtil.getGuestbook(guestbookId);
        }
        
        String headerTitle = (guestbook == null) ? "Add Guestbook" : guestbook.getName();

        portletDisplay.setShowBackIcon(true);
        portletDisplay.setURLBack(redirect);

        renderResponse.setTitle(headerTitle);
%>

<portlet:renderURL var="viewURL">
        <portlet:param name="mvcPath" value="/html/guestbookadminmvcportlet/view.jsp"></portlet:param>
</portlet:renderURL>

<portlet:actionURL name='<%= guestbook == null ? "addGuestbook" : "updateGuestbook" %>' var="editGuestbookURL" />

<aui:form action="<%= editGuestbookURL %>" name="<portlet:namespace />fm">
		<aui:model-context bean="<%= guestbook %>" model="<%= Guestbook.class %>" />
		
        <aui:fieldset>
                        <aui:input type="hidden" name="guestbookId"
                                value='<%= guestbook == null ? "" : guestbook.getGuestbookId() %>' />
                        <aui:input name="name" />
        </aui:fieldset>

        <aui:button-row>
                        <aui:button type="submit"></aui:button>
                        <aui:button type="cancel" onClick="<%= viewURL %>"></aui:button>
        </aui:button-row>
</aui:form>