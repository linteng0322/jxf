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
	
	function searchmaterial() {
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
				'${pageContext.request.contextPath}/material/searchmaterial',
				'material', popup_property);
	}

	 function searchandadd(uiElement) {
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
		'${pageContext.request.contextPath}/material/searchmaterialtry?uiElement='+uiElement,
		'material', popup_property);
	} 

	function addElement() {
		var x = document.getElementsByName("thickness");
	    var i=x.length;
		var fid = "searchmaterial";
		var materialId = "materialId";
		var thickness = "thickness";
		var color = "color";
		var length = "length";
		//var i = 10;
		i = i + 1;
		var id = $(this).parent().next().text();
		id = id.replace("\n", "").replace("\n", "").trim();
		var name = $(this).parent().next().next().text();
		var unitprice = $(this).parent().next().next().next().text();
		/* fid = fid + i; */
		$('#searchmaterialtable', document)
				.append(
						"<tr><td>"
								/* + "<input id='"
								+i
								+ "' type='text' name='sequence' readonly='readonly'/>"
								+ "</td><td>"
								 */+ "<input id='"
								+ "sequence" +i
								+ "' type='text' name='sequence' value=" +i +" style='width: 100px; padding: 4px;' readonly='true'/>"
								+"<input id='"
								+ fid+i
								+ "' type='hidden' name='materialchildren' style='width: 130px; padding: 4px;' readonly='readonly'/>"
								+ "</td><td>"
								+ "<input id='"
								+materialId+i
								+ "' type='search' name='materialId' style='width: 130px; padding: 4px;' onclick='searchandadd("+ "\""+i+"\"" + ")' required='true'/>"
								+ "</td><td>"
								+ "<input id='"
								+thickness+i
								+ "' type='text' name='thickness' style='width: 130px; padding: 4px;' readonly='readonly'/>"
								+ "</td><td>"
								+ "<input id='"
								+color+i
								+ "' type='text' name='color' style='width: 130px; padding: 4px;' readonly='readonly'/>"
								+ "</td><td>"
								+ "<input id='"
								+length+i
								+ "' type='text' name='length' style='width: 130px; padding: 4px;' readonly='readonly'/>"
								+ "</td></tr>");
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
			<sf:form servletRelativeAction="savecreatematerialgroup"
				method="post" modelAttribute="materialgroup"
				cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />

				<div class="panel panel-default">
					<!-- Default panel contents -->
					<div class="panel-heading">
						<sp:message code="label.material" />
					</div>
					<div class="form-group">
						<sf:label path="id" cssClass="col-sm-2 control-label">
							<sp:message code="label.materialid" />
							<span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="materialgroupId" path="materialgroupId" maxlength="20" style="text-transform:uppercase"
								cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="pinming" cssClass="col-sm-2 control-label">
							<sp:message code="label.pinming" /><span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="pinming" path="pinming" maxlength="20" required="true"
								cssClass="form-control" />
						</div>
					</div>
				</div>
				<a onclick="addElement()" title="Register">
					<span class="glyphicon glyphicon-plus"></span>
				</a>
				<div class="panel panel-default">
				<table id="searchmaterialtable"
					class="table table-striped table-bordered table-hover table-condensed">
					<thead>
						<tr>
							<th><sp:message code="label.id" /></th>
							<th><sp:message code="label.material" /></th>
							<th><sp:message code="label.thickness" /></th>
							<th><sp:message code="label.color" /></th>
							<th><sp:message code="label.length" /></th>
						</tr>
					</thead>
					<tbody>
						
					</tbody>
				</table>
				</div>
				<input id="materialchildrenstring" name="materialchildrenstring" type="hidden"
					value="${materialchildrenstring}">
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
