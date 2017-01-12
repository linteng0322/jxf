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
		if ($("#materialid").val() == "") {
			$("#cmaterial").addClass("current-menu-item"); //Add "active" class to selected tab  
		} else {
			$("#ordlist").addClass("current-menu-item"); //Add "active" class to selected tab  
		}

	});
	function searchmaterial() {
		var popup_width = 1024;
		var popup_height = 600;
		var popup_left = (screen.width - popup_width) / 2;
		var popup_top = (screen.height - popup_height) / 2;
		var popup_scrollbars = "yes";

		var popup_property = "width=" + popup_width;
		var popup_property = popup_property + ",height=" + popup_height;
		var popup_property = popup_property + ",left=" + popup_left;
		var popup_property = popup_property + ",top=" + popup_top;
		var popup_property = popup_property + ",scrollbars=" + popup_scrollbars;

		window.open(
				'${pageContext.request.contextPath}/material/searchmaterial',
				'material', popup_property);
	}
	function searchcustomer() {
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
				'${pageContext.request.contextPath}/customer/searchcustomer',
				'customer', popup_property);
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
			<sf:form servletRelativeAction="savecreatetransaction" method="post"
				modelAttribute="transaction" cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />
				
				<sf:hidden path="type" />
				<div class="panel panel-default">
					<!-- Default panel contents -->
					<div class="panel-heading">
					<c:if test="${transaction.type=='IN'}">
						<sp:message code="label.transactionin" />
					</c:if>
					<c:if test="${transaction.type!='IN'}">
						<sp:message code="label.transactionout" />
					</c:if>
					</div>
					<div class="form-group">
						<sf:label path="orderNo" cssClass="col-sm-2 control-label">
							<sp:message code="label.order" /><span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="orderNo" path="orderNo" required="required" maxlength="20"
								cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="" cssClass="col-sm-2 control-label">
							<sp:message code="label.customer" /><span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="customerIdentity" path="customer.id" readonly="true" required="required" onclick="searchcustomer()" maxlength="20"
								cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="" cssClass="col-sm-2 control-label">
							<sp:message code="label.customer" /><span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="customerFamilyName" path="customer.name" readonly="true" required="required" onclick="searchcustomer()" maxlength="20"
								cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="" cssClass="col-sm-2 control-label">
							<sp:message code="label.material" /><span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="materialIdentity" path="material.id" readonly="true" required="required" onclick="searchmaterial()" maxlength="20"
								cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="material.id" cssClass="col-sm-2 control-label">
							<sp:message code="label.materialid" /><span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="materialIdString" path="material.materialId" readonly="true" required="required" onclick="searchmaterial()" maxlength="20"
								cssClass="form-control" />
						</div>
					</div>
					<%-- <div class="form-group">
						<sf:label path="material.pinming" cssClass="col-sm-2 control-label">
							<sp:message code="label.pinming" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="material.pinming" path="material.pinming" maxlength="20"
								cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="material.thickness" cssClass="col-sm-2 control-label">
							<sp:message code="label.thickness" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="material.thickness" maxlength="20" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="material.thicknessunit" cssClass="col-sm-2 control-label">
							<sp:message code="label.thicknessunit" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="material.thicknessunit" maxlength="20" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="material.color" cssClass="col-sm-2 control-label">
							<sp:message code="label.color" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="material.color" maxlength="20" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="material.weight" cssClass="col-sm-2 control-label">
							<sp:message code="label.weight" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="material.weight" maxlength="20" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="material.weightunit" cssClass="col-sm-2 control-label">
							<sp:message code="label.weightunit" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="material.weightunit" maxlength="20"
								cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="material.length" cssClass="col-sm-2 control-label">
							<sp:message code="label.length" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="material.length" maxlength="20" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="material.lengthunit" cssClass="col-sm-2 control-label">
							<sp:message code="label.lengthunit" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="material.lengthunit" maxlength="20"
								cssClass="form-control" />
						</div>
					</div> --%>
					<div class="form-group">
						<sf:label path="count" cssClass="col-sm-2 control-label">
							<sp:message code="label.count" /><span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="count" required="required" maxlength="20" cssClass="form-control" />
						</div>
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
	</div>

	<%@ include file="../includes/footer.jsp"%>
</body>
</html>
