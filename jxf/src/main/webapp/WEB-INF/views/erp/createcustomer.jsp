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
			<sf:form servletRelativeAction="savecreatecustomer" method="post"
				modelAttribute="customer" cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />
				
				<div class="panel panel-default">
					<!-- Default panel contents -->
					<div class="panel-heading">
						<sp:message code="label.customer" />
					</div>
					<div class="form-group">
						<sf:label path="name" cssClass="col-sm-2 control-label">
							<sp:message code="label.client" /><span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="name" path="name" maxlength="50" style="width: 350px;"
								cssClass="form-control" />
						</div>
					</div>
					<%-- <div class="form-group">
						<sf:label path="phone" cssClass="col-sm-2 control-label">
							<sp:message code="label.phone" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="phone" maxlength="20"
								cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="title" cssClass="col-sm-2 control-label">
							<sp:message code="label.title" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="title" maxlength="20" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="location" cssClass="col-sm-2 control-label">
							<sp:message code="label.location" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="location" maxlength="20" cssClass="form-control" />
						</div>
					</div>
					
					<div class="form-group">
						<sf:label path="email" cssClass="col-sm-2 control-label">
							<sp:message code="label.email" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="email" maxlength="20" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="address" cssClass="col-sm-2 control-label">
							<sp:message code="label.address" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="address" maxlength="20"
								cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="zipCode" cssClass="col-sm-2 control-label">
							<sp:message code="label.zipcode" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="zipCode" maxlength="20" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="fax" cssClass="col-sm-2 control-label">
							<sp:message code="label.fax" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="fax" maxlength="20" cssClass="form-control" />
						</div>
					</div>
					
					
					<div class="form-group">
						<sf:label path="quality" cssClass="col-sm-2 control-label">
							<sp:message code="label.quality" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="quality" maxlength="20" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="clientType" cssClass="col-sm-2 control-label">
							<sp:message code="label.clienttype" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="clientType" maxlength="20" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="userType" cssClass="col-sm-2 control-label">
							<sp:message code="label.usertype" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="userType" maxlength="20" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="companyName" cssClass="col-sm-2 control-label">
							<sp:message code="label.companyname" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="companyName" maxlength="20" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="website" cssClass="col-sm-2 control-label">
							<sp:message code="label.website" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="website" maxlength="20" cssClass="form-control" />
						</div>
					</div> --%>

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
