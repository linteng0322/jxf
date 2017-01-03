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
		if ($("#materialId").val() == "") {
			$("#cmaterial").addClass("current-menu-item"); //Add "active" class to selected tab  
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
			<sf:form servletRelativeAction="savecreatematerial" method="post"
				modelAttribute="material" cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />
				
				<div class="panel panel-default">
					<!-- Default panel contents -->
					<div class="panel-heading">
						<sp:message code="label.material" />
					</div>
					<div class="form-group">
						<sf:label path="materialId" cssClass="col-sm-2 control-label">
							<sp:message code="label.materialid" /><span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="materialId" path="materialId" required="true" maxlength="20" style="text-transform:uppercase"
								cssClass="form-control" />
						</div>
					</div>
					<%-- <div class="form-group">
						<sf:label path="parent.materialId" cssClass="col-sm-2 control-label">
							<sp:message code="label.parentid" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="parent.materialId" path="parent.materialId" maxlength="20"
								cssClass="form-control" />
						</div>
					</div> --%>
					<div class="form-group">
						<sf:label path="pinming" cssClass="col-sm-2 control-label">
							<sp:message code="label.pinming" /><span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="pinming" path="pinming" maxlength="20" required="true"
								cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="thickness" cssClass="col-sm-2 control-label">
							<sp:message code="label.thickness" /><span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="thickness" maxlength="20" required="true" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="color" cssClass="col-sm-2 control-label">
							<sp:message code="label.color" /><span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="color" maxlength="20" required="true" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="weight" cssClass="col-sm-2 control-label">
							<sp:message code="label.weight" /><span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="weight" maxlength="20" required="true" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="length" cssClass="col-sm-2 control-label">
							<sp:message code="label.length" /><span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="length" maxlength="20" required="true" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="riskcount" cssClass="col-sm-2 control-label">
							<sp:message code="label.riskcount" /><span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="riskcount" maxlength="20" required="true"
								cssClass="form-control" />
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
