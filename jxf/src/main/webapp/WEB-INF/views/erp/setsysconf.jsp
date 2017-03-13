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
		if ($("#customerid").val() == "") {
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
			<sf:form servletRelativeAction="savesysconf" method="post"
				modelAttribute="sysconf" cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />
				<sf:hidden id="id" path="id" />

				<div class="panel panel-default">
					<!-- Default panel contents -->
					
					<div class="panel-heading">
						<sp:message code="app.menu.setting" />
					</div>
					<div class="form-group">
						<sf:label path="companyname" cssClass="col-sm-2 control-label">
							<sp:message code="label.companyname" />
							<span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="companyname" path="companyname" maxlength="50" style="width: 350px;"
								 />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="address" cssClass="col-sm-2 control-label">
							<sp:message code="label.address" />
							<span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="address" path="address" maxlength="50" style="width: 350px;"
								 />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="phone" cssClass="col-sm-2 control-label">
							<sp:message code="label.phone" />
							<span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="phone" path="phone" maxlength="50" style="width: 350px;"
								 />
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
