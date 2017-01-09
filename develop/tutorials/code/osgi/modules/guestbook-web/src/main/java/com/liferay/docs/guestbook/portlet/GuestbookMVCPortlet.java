package com.liferay.docs.guestbook.portlet;

import com.liferay.docs.guestbook.model.Entry;
import com.liferay.docs.guestbook.model.Guestbook;
import com.liferay.docs.guestbook.service.EntryServiceUtil;
import com.liferay.docs.guestbook.service.GuestbookServiceUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.service.ServiceContextFactory;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.PortalUtil;

import java.io.IOException;
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Component;

@Component(
	immediate = true,
	property = {
		"com.liferay.portlet.display-category=category.sample",
		"com.liferay.portlet.instanceable=true",
		"com.liferay.portlet.scopeable=true",
		"javax.portlet.name=guestbook",
		"javax.portlet.display-name=Guestbook",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/html/guestbookmvcportlet/view.jsp",
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user",
		"javax.portlet.supports.mime-type=text/html",
		"javax.portlet.expiration-cache=0"
	},
	service = Portlet.class
)
public class GuestbookMVCPortlet extends MVCPortlet {
	
	public void addEntry(ActionRequest request, ActionResponse response)
		       throws PortalException, SystemException {

		    ServiceContext serviceContext = ServiceContextFactory.getInstance(
		         Entry.class.getName(), request);

		    String userName = ParamUtil.getString(request, "name");
		    String email = ParamUtil.getString(request, "email");
		    String message = ParamUtil.getString(request, "message");
		    long guestbookId = ParamUtil.getLong(request, "guestbookId");
		    long entryId = ParamUtil.getLong(request, "entryId");

		    if (entryId > 0) {

		       try {

		         EntryServiceUtil.updateEntry(serviceContext.getUserId(),
		              guestbookId, entryId, userName, email, message,
		              serviceContext);

		         SessionMessages.add(request, "entryAdded");

		         response.setRenderParameter("guestbookId",
		              Long.toString(guestbookId));

		       } catch (Exception e) {
		    	   System.out.println(e);

		         SessionErrors.add(request, e.getClass().getName());

		         PortalUtil.copyRequestParameters(request, response);

		         response.setRenderParameter("mvcPath",
		              "/html/guestbookmvcportlet/edit_entry.jsp");
		       }

		    }
		            else {

		       try {
		         EntryServiceUtil.addEntry(serviceContext.getUserId(),
		              guestbookId, userName, email, message, serviceContext);

		         SessionMessages.add(request, "entryAdded");

		         response.setRenderParameter("guestbookId",
		              Long.toString(guestbookId));

		       } catch (Exception e) {
		         SessionErrors.add(request, e.getClass().getName());

		                            PortalUtil.copyRequestParameters(request, response);

		         response.setRenderParameter("mvcPath",
		              "/html/guestbookmvcportlet/edit_entry.jsp");
		       }
		    }

		}
	
	public void deleteEntry (ActionRequest request, ActionResponse response) {

	    long entryId = ParamUtil.getLong(request, "entryId");
	    long guestbookId = ParamUtil.getLong(request, "guestbookId");

	    try {

	       ServiceContext serviceContext = ServiceContextFactory.getInstance(
	         Entry.class.getName(), request);

	       response.setRenderParameter("guestbookId", Long.toString(guestbookId));

	       EntryServiceUtil.deleteEntry(entryId, serviceContext);

	    } catch (Exception e) {
	       System.out.println(e);

	       SessionErrors.add(request, e.getClass().getName());
	    }
	}

	public void addGuestbook(ActionRequest request, ActionResponse response)
	        throws PortalException, SystemException {

	    ServiceContext serviceContext = ServiceContextFactory.getInstance(
	        Guestbook.class.getName(), request);

	    String name = ParamUtil.getString(request, "name");

	    try {
	        GuestbookServiceUtil.addGuestbook(serviceContext.getUserId(),
	                name, serviceContext);

	        SessionMessages.add(request, "guestbookAdded");

	    } catch (Exception e) {
	        SessionErrors.add(request, e.getClass().getName());

	        response.setRenderParameter("mvcPath",
	            "/html/guestbookmvcportlet/edit_guestbook.jsp");
	    }

	}

	@Override
	public void render(RenderRequest renderRequest,
	        RenderResponse renderResponse) throws PortletException, IOException {

	    try {
	        ServiceContext serviceContext = ServiceContextFactory.getInstance(
	                Guestbook.class.getName(), renderRequest);

	        long groupId = serviceContext.getScopeGroupId();

	        long guestbookId = ParamUtil.getLong(renderRequest, "guestbookId");

	        List<Guestbook> guestbooks = GuestbookServiceUtil
	                .getGuestbooks(groupId);

	        if (guestbooks.size() == 0) {
	            Guestbook guestbook = GuestbookServiceUtil.addGuestbook(
	                    serviceContext.getUserId(), "Main", serviceContext);

	            guestbookId = guestbook.getGuestbookId();

	        }

	        if (!(guestbookId > 0)) {
	            guestbookId = guestbooks.get(0).getGuestbookId();
	        }

	        renderRequest.setAttribute("guestbookId", guestbookId);

	    } catch (Exception e) {

	        throw new PortletException(e);
	    }

	    super.render(renderRequest, renderResponse);

	}
}