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
	function selectMaterial() {
		/* var materialchildrenstring = $("#materialchildrenstring").val(); */
		var uiElement = $("#uiElement").val();
		var uiElementObject="searchmaterial"+uiElement;
		var matchmaterialIduiElementObject="matchmaterialId"+uiElement;
		var matchmaterialidentityuiElementObject="matchmaterialidentity"+uiElement;
		var val = $('input:radio[name="materialId"]:checked').val();
		var materialIdString = $('input:radio[name="materialId"]:checked').parent().next().text();
		materialIdString = materialIdString.replace("\n", "").replace("\n","").trim();
		
		if (val == null) {
			alert("Please select one material");
			return false;
		} else {
			
			$('#'+matchmaterialIduiElementObject, window.opener.document).val(materialIdString);//materialId string
			$('#'+matchmaterialidentityuiElementObject, window.opener.document).val(val);// material identity
			
			
			window.close();
		}
		//how to get the uiElement from parent
		//set material identity back to id field
		//set materialId String back to value field
		
	}
</script>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<body class="home">
	<div id="page">
		<%@ include file="../includes/header.jsp"%>

		<div style="width: 100%;">

			<sf:form servletRelativeAction="searchmaterial" method="post"
				modelAttribute="material" cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />
				<%-- <input id="po" name="po" type="hidden" value="${po}"> --%>
				<input id="uiElement" name="uiElement" type="hidden"
					value="${uiElement}">
				<%-- <input id="materialchildrenstring" name="materialchildrenstring" type="hidden"
					value="${materialchildrenstring}"> --%>


				<div class="form-group">
					<div class="col-sm-2">
						<button type="submit" class="btn btn-primary">
							<sp:message code="label.search" />
						</button>
					</div>
				</div>

				<div class="panel panel-default"
					style="width: 100%; overflow: auto; position: relative;">
					<table
						class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th>&nbsp;</th>
								<th><sp:message code="label.materialid" /></th>
								<th><sp:message code="label.thickness" /></th>
								<th><sp:message code="label.color" /></th>
								<th><sp:message code="label.length" /></th>
								<th><sp:message code="label.stock" /></th>
							</tr>
						</thead>
						<%--@elvariable id="users" type="java.util.List"--%>
						<c:forEach var="material" items="${materiallist}" varStatus="loop">
							<tr>
								<td><sf:radiobutton path="materialId"
										value="${material.id}" /></td>
								<td><c:out value="${material.materialId}" /></td>
								<td><c:out value="${material.thickness}" /></td>
								<td><c:out value="${material.color}" /></td>
								<td><c:out value="${material.length}" /></td>
								<td><c:out value="${material.count}" /></td>
							</tr>
						</c:forEach>
					</table>
				</div>
				<div class="col-sm-2">
					<button type="button" class="btn btn-primary"
						onclick="selectMaterial()">
						<sp:message code="operate.save" />
					</button>
				</div>
				<br />
			</sf:form>
		</div>

	</div>

	<%@ include file="../includes/footer.jsp"%>
</body>
</html>
