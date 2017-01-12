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
		var materialIduiElementObject="materialId"+uiElement;
		var thicknessuiElementObject="thickness"+uiElement;
		var coloruiElementObject="color"+uiElement;
		var lengthuiElementObject="length"+uiElement;
		var stockuiElementObject="stock"+uiElement;
		var val = $('input:radio[name="materialId"]:checked').val();
		var materialIdString = $('input:radio[name="materialId"]:checked').parent().next().text();
		materialIdString = materialIdString.replace("\n", "").replace("\n","").trim();
		var thicknessString = $('input:radio[name="materialId"]:checked').parent().next().next().text();
		thicknessString = thicknessString.replace("\n", "").replace("\n","").trim();
		var colorString = $('input:radio[name="materialId"]:checked').parent().next().next().next().text();
		colorString = colorString.replace("\n", "").replace("\n","").trim();
		var lengthString = $('input:radio[name="materialId"]:checked').parent().next().next().next().next().text();
		lengthString = lengthString.replace("\n", "").replace("\n","").trim();
		//var countString; transaction count, no need to return back, will be input as transaction count
		/* 	
		var stockString = $('input:radio[name="materialId"]:checked').parent().next().next().next().next().next().text();
		stockString = stockString.replace("\n", "").replace("\n","").trim();
		 */
		
		if (val == null) {
			alert("Please select one material");
			return false;
		} else {
			/* materialchildrenstring = materialchildrenstring + "," + val; */
			/* $('#'+materialchildrenstring, window.opener.document).val(materialchildrenstring); */
			$('#'+uiElementObject, window.opener.document).val(val);
			$('#'+materialIduiElementObject, window.opener.document).val(materialIdString);
			$('#'+thicknessuiElementObject, window.opener.document).val(thicknessString);
			$('#'+coloruiElementObject, window.opener.document).val(colorString);
			$('#'+lengthuiElementObject, window.opener.document).val(lengthString);
			//$('#'+stockuiElementObject, window.opener.document).val(stockString);
			
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
