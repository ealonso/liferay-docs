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
long guestbookId = ParamUtil.getLong(renderRequest, "guestbookId");

String displayStyle = ParamUtil.getString(request, "displayStyle", "list");

String orderByCol = ParamUtil.getString(request, "orderByCol", "name");

boolean orderByAsc = false;

String orderByType = ParamUtil.getString(request, "orderByType", "asc");

if (orderByType.equals("asc")) {
	orderByAsc = true;
}

OrderByComparator orderByComparator = null;

if (orderByCol.equals("name")) {
	orderByComparator = new EntryNameComparator(orderByAsc);
}
%>

<aui:nav-bar markupView="lexicon">
	<aui:nav cssClass="navbar-nav">

		<%
		List<Guestbook> guestbooks = GuestbookLocalServiceUtil.getGuestbooks(scopeGroupId);

		for (Guestbook curGuestbook : guestbooks) {
			if (GuestbookPermission.contains(permissionChecker, curGuestbook.getGuestbookId(), "VIEW")) {
		%>

				<portlet:renderURL var="viewPageURL">
					<portlet:param name="mvcPath" value="/html/guestbookmvcportlet/view.jsp" />
					<portlet:param name="guestbookId" value="<%= String.valueOf(curGuestbook.getGuestbookId()) %>" />
				</portlet:renderURL>

				<aui:nav-item href="<%= viewPageURL %>" label="<%= HtmlUtil.escape(curGuestbook.getName()) %>" selected="<%= curGuestbook.getGuestbookId() == guestbookId %>" />

		<%
			}
		}
		%>

	</aui:nav>
</aui:nav-bar>

<liferay-portlet:renderURL varImpl="viewPageURL">
	<portlet:param name="mvcPath" value="/html/guestbookmvcportlet/view.jsp" />
	<portlet:param name="guestbookId" value="<%= String.valueOf(guestbookId) %>" />
</liferay-portlet:renderURL>

<liferay-frontend:management-bar>
	<liferay-frontend:management-bar-buttons>
		<liferay-frontend:management-bar-display-buttons
			displayViews='<%= new String[] {"list"} %>'
			portletURL="<%= viewPageURL %>"
			selectedDisplayStyle="<%= displayStyle %>"
		/>
	</liferay-frontend:management-bar-buttons>

	<liferay-frontend:management-bar-filters>
		<liferay-frontend:management-bar-navigation
			navigationKeys='<%= new String[] {"all"} %>'
			portletURL="<%= viewPageURL %>"
		/>

		<liferay-frontend:management-bar-sort
			orderByCol="<%= orderByCol %>"
			orderByType="<%= orderByType %>"
			orderColumns='<%= new String[] {"name"} %>'
			portletURL="<%= viewPageURL %>"
		/>
	</liferay-frontend:management-bar-filters>
</liferay-frontend:management-bar>

<aui:button-row cssClass="guestbook-buttons">
	<c:if test='<%= GuestbookModelPermission.contains(permissionChecker, scopeGroupId, "ADD_GUESTBOOK") %>'>
		<portlet:renderURL var="addGuestbookURL">
			<portlet:param name="mvcPath" value="/html/guestbookmvcportlet/edit_guestbook.jsp" />
		</portlet:renderURL>

		<aui:button onClick="<%= addGuestbookURL %>" value="Add Guestbook" />
	</c:if>

	<c:if test='<%= (guestbookId > 0) && GuestbookPermission.contains(permissionChecker, guestbookId, "ADD_ENTRY") %>'>
		<portlet:renderURL var="addEntryURL">
			<portlet:param name="mvcPath" value="/html/guestbookmvcportlet/edit_entry.jsp" />
			<portlet:param name="guestbookId" value="<%= String.valueOf(guestbookId) %>" />
		</portlet:renderURL>

		<aui:button onClick="<%= addEntryURL %>" value="Add Entry" />
	</c:if>
</aui:button-row>

<liferay-ui:search-container
	total="<%= EntryLocalServiceUtil.getEntriesCount(scopeGroupId, guestbookId) %>"
>
	<liferay-ui:search-container-results
		results="<%= EntryLocalServiceUtil.getEntries(scopeGroupId, guestbookId, searchContainer.getStart(), searchContainer.getEnd(), orderByComparator) %>"
	/>

	<liferay-ui:search-container-row
		className="com.liferay.docs.guestbook.model.Entry"
		modelVar="entry"
	>
		<liferay-ui:search-container-column-text
			property="message"
		/>

		<liferay-ui:search-container-column-text
			property="name"
		/>

		<liferay-ui:search-container-column-jsp
			align="right"
			path="/html/guestbookmvcportlet/guestbook_actions.jsp"
		/>
	</liferay-ui:search-container-row>

	<liferay-ui:search-iterator displayStyle="<%= displayStyle %>" markupView="lexicon" />
</liferay-ui:search-container>