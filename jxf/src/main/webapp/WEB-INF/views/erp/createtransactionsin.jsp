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
		setlist();
		setcustomerlist();
	});

	function setcustomerlist() {
		$.ajax({
			type : "POST",
			dataType : "text",
			url : "${pageContext.request.contextPath}/customer/getallcustomer",
			//data:"",
			contentType : "text/html; charset=utf-8",
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				alert(1);
			},
			success : function(data) {
				if (data != "true") {
					var dataList = document.getElementById('custlist');
					customers = data.split(",");
					for (var i = 0; i < customers.length; i++) {
						var option = document.createElement('option');
						option.value = customers[i];
						dataList.appendChild(option);
					}
				}
			}
		});
	}
	function setlist() {
		$
				.ajax({
					type : "POST",
					dataType : "text",
					url : "${pageContext.request.contextPath}/jxforder/getallmaterialorder",
					//data:"",
					contentType : "text/html; charset=utf-8",
					error : function(XMLHttpRequest, textStatus, errorThrown) {
						alert(1);
					},
					success : function(data) {
						if (data != "true") {
							var dataList = document
									.getElementById('json-datalist');
							materials = data.split(",");
							for (var i = 0; i < materials.length; i++) {
								var option = document.createElement('option');
								option.value = materials[i];
								// Add the <option> element to the <datalist>.
								dataList.appendChild(option);
							}
						}
					}
				});
	}
	function inputthisrow(row, input) {
		var materialstring = input.value;
		var materialparams = materialstring.split(";");
		$('#materialId' + row).val(materialparams[0]);
		$('#thickness' + row).val(materialparams[1]);
		$('#color' + row).val(materialparams[2]);
		$('#length' + row).val(materialparams[3]);
	}
	function selectthiscustomer(input) {
		var customerstring = input.value;
		var customerparams = customerstring.split(";");
		if (customerparams[0] != "") {
			$('#customerFamilyName').val(customerparams[0] + customerparams[1]);
		}
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
				'${pageContext.request.contextPath}/transaction/searchelementtry?uiElement='
						+ uiElement, 'material', popup_property);
	}
	function addElement() {
		var x = document.getElementsByName("materialchildren");
		var i = x.length;
		var fid = "searchmaterial";
		var materialId = "materialId";
		var thickness = "thickness";
		var color = "color";
		var length = "length";
		var materialcount = "materialcount";
		var stock = "stock";
		var materialtype = "materialtype";
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
						+ fid+i
						+ "' type='hidden' name='materialchildren' style='width: 100px; padding: 4px;' readonly='true'/>"
								+ "<input id='"
						+ fid+i
						+ "' type='text' name='sequence' value=" +i +" style='width: 100px; padding: 4px;' readonly='true'/>"
								+ "</td><td>"
								+ "<input id='"
								+ materialId
								+ i
								//+ "' type='search' name='materialId' style='width: 100px; padding: 4px;' onclick='searchandadd("+ "\""+i+"\"" + ")' readonly='readonly'/>"
								+ "' name='materialId' list='json-datalist' style='width: 100px; padding: 4px; text-transform:uppercase;'"
								+ "oninput='inputthisrow("
								+ i
								+ ", this)' />"
								+ "<datalist id='json-datalist'></datalist>"
								+ "</td><td>"
								+ "<input id='"
						+thickness+i
						+ "' type='text' name='thickness' style='width: 100px; padding: 4px; border: none; background: transparent;' readonly='true'/>"
								+ "</td><td>"
								+ "<input id='"
						+color+i
						+ "' type='text' name='color' style='width: 100px; padding: 4px; border: none; background: transparent;' readonly='true'/>"
								+ "</td><td>"
								+ "<input id='"
						+length+i
						+ "' type='text' name='length' style='width: 100px; padding: 4px; border: none; background: transparent;' readonly='true'/>"
								+ "</td><td>"
								+ "<input id='"
						+materialcount+i
						+ "' type='text' name='materialcount' style='width: 100px; padding: 4px;' />"
								/* + "</td><td>"
								+ "<input id='"
						+stock+i
						+ "' type='text' name='stock' style='width: 100px; padding: 4px;' readonly='true'/>"
								+ ""
								+ "<input id='"
						+materialtype+i
						+ "' type='hidden' name='materialtype' style='width: 100px; padding: 4px;' readonly='true'/>" */
								+ "</td></tr>");
	}
	function submitorder() {
		var appendstring;
		var additionalmaterialstring;
		var x = document.getElementsByName("sequence");
		var i = x.length;
		var materialorderstring;
		var flag = "";
		for (var j = 1; j <= i; j++) {
			var elementid = "sequence" + j;
			var sequence = $('input:text[id="' + elementid + '"]').val();
			elementid = "identity" + j;//materialorder identity
			var identity = $('input:hidden[id="' + elementid + '"]').val();
			elementid = "materialId" + j;//materialorder materialId
			var materialId = $('input:text[id="' + elementid + '"]').val();
			elementid = "thickness" + j;
			var thickness = $('input:text[id="' + elementid + '"]').val();
			elementid = "color" + j;
			var color = $('input:text[id="' + elementid + '"]').val();
			elementid = "length" + j;
			var length = $('input:text[id="' + elementid + '"]').val();
			elementid = "materialcount" + j;
			var materialcount = $('input:text[id="' + elementid + '"]').val();
			if (materialId != "") {
				if (flag == "") {
					appendstring = identity + ";" + materialId + ";"
							+ thickness + ";" + color + ";" + length + ";"
							+ materialcount;
					flag = "has";
				} else {
					appendstring = appendstring + "," + identity + ";"
							+ materialId + ";" + thickness + ";" + color + ";"
							+ length + ";" + materialcount;
				}
			}
		}
		$('#materialidstring').val(appendstring);
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
			<sf:form servletRelativeAction="savecreatetransactionsin"
				method="post" modelAttribute="transaction"
				cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />

				<sf:hidden path="type" />
				<div class="panel panel-default">
					<!-- Default panel contents -->
					<div class="panel-heading">
						<sp:message code="label.transactionin" />
					</div>
					<div class="form-group">
						<sf:label path="orderNo" cssClass="col-sm-2 control-label">
							<sp:message code="label.order" />
							<span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="orderNo" path="orderNo" required="required"
								maxlength="20" cssClass="form-control" />
						</div>
					</div>
					<%-- <sf:input id="customerIdentity" type="hidden" path="customer.id"
						required="required" maxlength="20"
						cssClass="form-control" /> --%>
					<%-- </div>
					</div> --%>
					<div class="form-group">
						<sf:label path="" cssClass="col-sm-2 control-label">
							<sp:message code="label.factory" />
							<span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<%-- <input list="json-datalist"
										id='materialId<c:out value="${loop.index+1}"/>'
										name="materialId" type="text"
										value='<c:out value="${ordermaterial.orderMaterialId}"/>'
										style='width: 100px; padding: 4px; text-transform: uppercase' 
										oninput="inputthisrow(<c:out value="${loop.index+1}"/>, this)"/>
										
										
										
								+ "<input id='"
								+ materialId
								+ i
								//+ "' type='search' name='materialId' style='width: 100px; padding: 4px;' onclick='searchandadd("+ "\""+i+"\"" + ")' readonly='readonly'/>"
								+ "' name='materialId' list='json-datalist' style='width: 100px; padding: 4px; text-transform:uppercase;'"
								+ "oninput='inputthisrow("
								+ i
								+ ", this)' />"
								+ "<datalist id='json-datalist'></datalist>"
										 --%>
							<input id="customerFamilyName" type="search" name="customer.name"
								required="required" list="custlist" maxlength="50"
								style="width: 350px; background: white; border: 1px solid #d3d3d3; box-shadow: inset 0 0 2px #ccc; padding: 7px 6px; color: #77797e;" />
							<datalist id="custlist">
							</datalist>
						</div>
					</div>
				</div>
				<datalist id="json-datalist">
				</datalist>
				<a onclick="addElement()" title="Register"> <span
					class="glyphicon glyphicon-plus"></span>
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
								<th><sp:message code="label.count" /></th>
								<%-- <th><sp:message code="label.stock" /></th> --%>
							</tr>
						</thead>
						<tbody>

						</tbody>
					</table>
				</div>
				<input id="materialidstring" name="materialidstring" type="hidden"
					value="${materialidstring}">
				<div class="form-group">
					<div class="col-sm-offset-3 col-sm-1">
						<button type="submit" class="btn btn-primary"
							onclick="submitorder()">
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
