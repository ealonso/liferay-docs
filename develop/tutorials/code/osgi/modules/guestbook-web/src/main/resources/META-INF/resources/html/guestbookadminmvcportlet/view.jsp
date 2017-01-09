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

<aui:button-row cssClass="guestbook-admin-buttons">
        <c:if test='<%= GuestbookModelPermission.contains(permissionChecker,
             scopeGroupId, "ADD_GUESTBOOK") %>'>
                <portlet:renderURL var="addGuestbookURL">
                        <portlet:param name="mvcPath"
                                value="/html/guestbookadminmvcportlet/edit_guestbook.jsp" />
                </portlet:renderURL>

                <aui:button onClick="<%= addGuestbookURL.toString() %>"
                        value="Add Guestbook" />
        </c:if>
</aui:button-row>

<liferay-ui:search-container total="<%= GuestbookLocalServiceUtil.getGuestbooksCount(scopeGroupId) %>" >
        <liferay-ui:search-container-results
                results="<%= GuestbookLocalServiceUtil.getGuestbooks(scopeGroupId,
                                                searchContainer.getStart(),
                                                searchContainer.getEnd()) %>" />

        <liferay-ui:search-container-row
                className="com.liferay.docs.guestbook.model.Guestbook" modelVar="guestbook">

                <liferay-ui:search-container-column-text property="name" />

                <liferay-ui:search-container-column-jsp
                    path="/html/guestbookadminmvcportlet/guestbook_actions.jsp"
                    align="right" />

        </liferay-ui:search-container-row>

        <liferay-ui:search-iterator />
</liferay-ui:search-container>