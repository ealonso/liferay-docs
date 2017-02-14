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
String displayStyle = ParamUtil.getString(request, "displayStyle", "list");

String orderByCol = ParamUtil.getString(request, "orderByCol", "name");

boolean orderByAsc = false;

String orderByType = ParamUtil.getString(request, "orderByType", "asc");

if (orderByType.equals("asc")) {
	orderByAsc = true;
}

OrderByComparator orderByComparator = null;

if (orderByCol.equals("name")) {
	orderByComparator = new GuestbookNameComparator(orderByAsc);
}
%>

<aui:nav-bar cssClass="collapse-basic-search" markupView="lexicon">
	<aui:nav cssClass="navbar-nav">
		<aui:nav-item label="Guestbooks" selected="<%= true %>" />
	</aui:nav>
</aui:nav-bar>

<liferay-portlet:renderURL varImpl="viewPageURL">
	<portlet:param name="mvcPath" value="/html/guestbookadminmvcportlet/view.jsp" />
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

<div class="container-fluid-1280">
	<liferay-ui:search-container
		total="<%= GuestbookLocalServiceUtil.getGuestbooksCount(scopeGroupId) %>"
	>
		<liferay-ui:search-container-results
			results="<%= GuestbookLocalServiceUtil.getGuestbooks(scopeGroupId, searchContainer.getStart(), searchContainer.getEnd(), orderByComparator) %>"
		/>

		<liferay-ui:search-container-row
			className="com.liferay.docs.guestbook.model.Guestbook"
			modelVar="guestbook"
		>
			<liferay-ui:search-container-column-text
				property="name"
			/>

			<liferay-ui:search-container-column-jsp
				align="right"
				path="/html/guestbookadminmvcportlet/guestbook_actions.jsp"
			/>
		</liferay-ui:search-container-row>

		<liferay-ui:search-iterator displayStyle="<%= displayStyle %>" markupView="lexicon" />
	</liferay-ui:search-container>
</div>

<liferay-frontend:add-menu>
	<c:if test='<%= GuestbookModelPermission.contains(permissionChecker, scopeGroupId, "ADD_GUESTBOOK") %>'>
		<portlet:renderURL var="addGuestbookURL">
			<portlet:param name="mvcPath" value="/html/guestbookadminmvcportlet/edit_guestbook.jsp" />
			<portlet:param name="redirect" value="<%= currentURL %>" />
		</portlet:renderURL>

		<liferay-frontend:add-menu-item title="Add Guestbook" url="<%= addGuestbookURL.toString() %>" />
	</c:if>
</liferay-frontend:add-menu>