<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="../init.jsp" %>

<%
long entryId = ParamUtil.getLong(renderRequest, "entryId");

Entry entry = null;

if (entryId > 0) {
	entry = EntryLocalServiceUtil.getEntry(entryId);
}

long guestbookId = ParamUtil.getLong(renderRequest, "guestbookId");
%>

<portlet:renderURL var="viewURL">
	<portlet:param name="mvcPath" value="/html/guestbookmvcportlet/view.jsp" />
</portlet:renderURL>

<portlet:actionURL name="addEntry" var="addEntryURL" />

<aui:form action="<%= addEntryURL %>" name="fm">
	<aui:model-context bean="<%= entry %>" model="<%= Entry.class %>" />

	<aui:fieldset>
		<aui:input name="name" />

		<aui:input name="email" />

		<aui:input name="message" />

		<aui:input name="entryId" type="hidden" />

		<aui:input name="guestbookId" type="hidden" value="<%= entry == null ? guestbookId : entry.getGuestbookId() %>" />
	</aui:fieldset>

	<aui:button-row>
		<aui:button type="submit" />

		<aui:button onClick="<%= viewURL.toString() %>" type="cancel" />
	</aui:button-row>
</aui:form>