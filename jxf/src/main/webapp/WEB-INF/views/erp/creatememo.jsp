<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sp" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix='sec'
	uri='http://www.springframework.org/security/tags'%>
<%@ taglib prefix="d" uri="https://github.com/xpjsky/devices/tags"%>
<html>
<head>

<title>JXF</title>

<%@ include file="../includes/jsheader.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		if ($("#customerId").val() == "") {
			$("#ccustomer").addClass("current-menu-item"); //Add "active" class to selected tab  
		} else {
			$("#ordlist").addClass("current-menu-item"); //Add "active" class to selected tab  
		}

	});
	
	function searchsalesman() {
		var popup_width = 1024;
		var popup_height = 600;
		var popup_left = (screen.width - popup_width) / 2;
		var popup_top = (screen.height - popup_height) / 2;
		var popup_scrollbars = "no";

		var popup_property = "width=" + popup_width;
		var popup_property = popup_property + ",height=" + popup_height;
		var popup_property = popup_property + ",left=" + popup_left;
		var popup_property = popup_property + ",top=" + popup_top;
		var popup_property = popup_property + ",scrollbars=" + popup_scrollbars;

		window.open(
				'${pageContext.request.contextPath}/salesman/searchsalesman',
				'salesman', popup_property);
	}
</script>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<body class="home">
	<div id="page">
		<%@ include file="../includes/header.jsp"%>
		<div id="csidebar" style="float: left; width: 20%;">
			<%@ include file="../includes/csidebar.jsp"%>
		</div>
		<div style="float: right; width: 80%;">
			<div class="panel panel-default">
				<!-- Default panel contents -->
				<div class="panel-heading">
					<sp:message code="label.memo" />
				</div>
			</div>
			<sf:form servletRelativeAction="savecreatememo" method="post"
				modelAttribute="memo" cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />


				<div class="form-group">
						<sf:label path="orderId" cssClass="col-sm-2 control-label">
							<sp:message code="label.order" />
							<span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="orderId" path="orderId" required="required"
								maxlength="20" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="customer.name" cssClass="col-sm-2 control-label">
							<sp:message code="label.customer" />
							<span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<input id="customerFamilyName" type="search" name="customer.name"
								required="required" list="custlist" maxlength="50" value='<c:out value="${order.customer.name}"/>'
								style="width: 350px; background: white; border: 1px solid #d3d3d3; box-shadow: inset 0 0 2px #ccc; padding: 7px 6px; color: #77797e;" />
							<datalist id="custlist">
							</datalist>
						</div>
					</div>
				<div class="form-group">
					<sf:label path="salesman.name" cssClass="col-sm-2 control-label">
						<sp:message code="label.salesman" />
					</sf:label>
					<div class="col-sm-2">
						<sf:input id="salesmanid" path="salesman.id" type="hidden"
							maxlength="20" cssClass="form-control" />
						<sf:input id="salesmanname" path="salesman.name"
							onclick="searchsalesman()" maxlength="20" cssClass="form-control" />
					</div>
				</div>
				<div class="form-group">
					<div class="col-sm-offset-3 col-sm-1">
						<button type="submit" class="btn btn-primary">
							<sp:message code="operate.save" />
						</button>
					</div>

					<div class="col-md-offset-3 col-sm-1">
						<button type="button" class="btn btn-default"
							onclick="history.go(-1);">
							<sp:message code="operate.cancel" />
						</button>
					</div>
				</div>
			</sf:form>

		</div>

		<%@ include file="../includes/footer.jsp"%>
</body>
</html>
