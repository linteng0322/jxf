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
	//importClass(Packages.com.jxf.oa.entity.MaterialOrder);
	$(document).ready(function() {
		if ($("#materialid").val() == "") {
			$("#cmaterial").addClass("current-menu-item"); //Add "active" class to selected tab  
		} else {
			$("#ordlist").addClass("current-menu-item"); //Add "active" class to selected tab  
		}
		setcustomerlist();
		setlist();

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
						var custstring = $('input[id="customerFamilyName"]').val();
						if(customers[i]==custstring)
							option.selected=true;
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
							//alert(data);
							var dataList = document
									.getElementById('json-datalist');
							//var input = document.getElementById('materialId1');
							// Create a new <option> element.

							// Set the value using the item in the JSON array.
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

	function inputthisrow(row, input) {
		var materialstring = input.value;
		var materialparams = materialstring.split(";");
		$('#materialId' + row).val(materialparams[0]);
		$('#thickness' + row).val(materialparams[1]);
		$('#color' + row).val(materialparams[2]);
		$('#length' + row).val(materialparams[3]);
	}
	function addmultipleElement() {
		for (var i = 0; i < 10; i++) {
			addElement();
		}
		//setlist();
	}
	function addElement() {
		var x = document.getElementsByName("sequence");
		var i = x.length;
		var fid = "sequence";
		var identity = "identity";
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

		//var materialorder = new MaterialOrder();
		//materialorderlist.add(materialorder);
		/* fid = fid + i; */
		$('#searchmaterialtable', document)
				.append(
						"<tr><td>"
								+ "<input id='"
								+ "sequence"+i
								+ "' type='text' name='sequence' value=" +i + " style='width: 100px; padding: 4px;' readonly='readonly'/>"
								+ "<input id='"
								+ identity+i
								+ "' type='hidden' name='identity' value='' style='width: 100px; padding: 4px;' />"
								+ "</td><td>"
								+ "<input id='"
								+ materialId
								+ i
								+ "' type='text' name='materialId' list='json-datalist' style='width: 100px; padding: 4px; text-transform:uppercase;'"
								+ "oninput='inputthisrow("
								+ i
								+ ", this)'/>"
								+ "<datalist id='json-datalist'></datalist>"
								+ "</td><td>"
								+ "<input id='"
								+thickness+i
								+ "' type='text' name='thickness' style='width: 100px; padding: 4px;' />"
								+ "</td><td>"
								+ "<input id='"
								+color+i
								+ "' type='text' name='color' style='width: 100px; padding: 4px;' />"
								+ "</td><td>"
								+ "<input id='"
								+length+i
								+ "' type='text' name='length' style='width: 100px; padding: 4px;' />"
								+ "</td><td>"
								+ "<input id='"
								+materialcount+i
								+ "' type='text' name='materialcount' style='width: 100px; padding: 4px;' />"
								+ "</td></tr>");

	}

	function addadditionalmaterial() {
		var x = document.getElementsByName("additionalsequence");
		var i = x.length;
		var additionalmaterialname = "additionalmaterialname";
		i = i + 1;

		$('#additionalmaterialtable', document)
				.append(
						"<tr><td>"
								+ "<input id='"
								+ "additionalsequence"+i +"'"
								+ " type='text' name='additionalsequence' value=" +i + " style='width: 100px; padding: 4px;' />"
								+ "</td><td>"
								+ "<input id='additionalmaterialname"+i + "'"
								+ " type='text' name='additionalmaterialname' style='width: 100px; padding: 4px;' />"
								+ "</td><td>"
								+ "<input id='additionalmaterialcount"+i + "'"
								+ " type='text' name='additionalmaterialcount' style='width: 100px; padding: 4px;' />"
								+ "</td></tr>");
	}

	function submitorder() {
		var salesmanid = $('input:hidden[id="salesmanid"]').val();
		var salesmanname = $('input:text[id="salesmanname"]').val();
		if (salesmanname == "") {
			$('#salesmanid').val("");
		}
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
		$('#materialchildrenstring').val(appendstring);
		var x = document.getElementsByName("additionalsequence");
		var i = x.length;
		var flag = "";
		var additionalmaterialstring = "";
		for (var j = 1; j <= i; j++) {
			var additionalmaterialname = $(
					'input:text[id="additionalmaterialname' + j + '"]').val();
			var additionalmaterialcount = $(
					'input:text[id="additionalmaterialcount' + j + '"]').val();

			if (additionalmaterialname != "") {
				if (flag == "") {
					additionalmaterialstring = additionalmaterialname + ";"
							+ additionalmaterialcount;
					flag = "has";
				} else {
					additionalmaterialstring = additionalmaterialstring + ","
							+ additionalmaterialname + ";"
							+ additionalmaterialcount;
				}
			}
		}

		$('#additionalmaterialstring').val(additionalmaterialstring);
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
			<sf:form servletRelativeAction="savecreateorder" method="post"
				modelAttribute="order" cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />
				<sf:hidden id="id" path="id" />
				<%-- <sf:hidden path="type" /> --%>
				<div class="panel panel-default">
					<!-- Default panel contents -->
					<div class="panel-heading">
						<sp:message code="label.orderout" />
					</div>
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
					<%-- <sf:input type="hidden" id="customerIdentity"
						name="customerIdentity" path="customer.id"
						onclick="searchcustomer()" required="required" maxlength="20"
						cssClass="form-control" /> --%>
					<div class="form-group">
						<sf:label path="customer.name" cssClass="col-sm-2 control-label">
							<sp:message code="label.customer" />
							<span class="required">*</span>
						</sf:label>
						<div class="col-sm-2">
							<%-- <sf:input id="customerFamilyName" path="customer.name"
								required="required" onclick="searchcustomer()" maxlength="20"
								cssClass="form-control" /> --%>
							<input id="customerFamilyName" type="search" name="customer.name"
								required="required" list="custlist" maxlength="50" value='<c:out value="${order.customer.name}"/>'
								style="width: 350px; background: white; border: 1px solid #d3d3d3; box-shadow: inset 0 0 2px #ccc; padding: 7px 6px; color: #77797e;" />
							<datalist id="custlist">
							</datalist>
						</div>
					</div>
				</div>
				<datalist id="json-datalist">
				</datalist>
				<a onclick="addmultipleElement()" title="Register"> <span
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
							</tr>
						</thead>
						<tbody>
							<c:forEach var="ordermaterial" items="${order.materialorderlist}"
								varStatus="loop">

								<tr>
									<td><input id='sequence<c:out value="${loop.index+1}"/>'
										name="sequence" type="text" value="${loop.index+1}"
										style='width: 100px; padding: 4px;' /> <input
										id='identity<c:out value="${loop.index+1}"/>' name="identity"
										type="hidden" value="${ordermaterial.id}"
										style='width: 100px; padding: 4px;' /></td>
									<td><input list="json-datalist"
										id='materialId<c:out value="${loop.index+1}"/>'
										name="materialId" type="text"
										value='<c:out value="${ordermaterial.orderMaterialId}"/>'
										style='width: 100px; padding: 4px; text-transform: uppercase'
										oninput="inputthisrow(<c:out value="${loop.index+1}"/>, this)" />
										<datalist id="json-datalist">
										</datalist></td>
									<td><input id='thickness<c:out value="${loop.index+1}"/>'
										name="thickness" type="text"
										value='<c:out value="${ordermaterial.orderThickness}"/>'
										style='width: 100px; padding: 4px;' /></td>
									<td><input id='color<c:out value="${loop.index+1}"/>'
										name="color" type="text"
										value='<c:out value="${ordermaterial.orderColor}"/>'
										style='width: 100px; padding: 4px;' /></td>
									<td><input id='length<c:out value="${loop.index+1}"/>'
										name="length" type="text"
										value='<c:out value="${ordermaterial.orderLength}"/>'
										style='width: 100px; padding: 4px;' /></td>
									<td><input
										id='materialcount<c:out value="${loop.index+1}"/>'
										name="materialcount" type="text"
										value='<c:out value="${ordermaterial.orderCount}"/>'
										style='width: 100px; padding: 4px;' /></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<a onclick="addadditionalmaterial()" title="Register"> <span
					class="glyphicon glyphicon-plus"></span>
				</a>
				<div class="panel panel-default">
					<table id="additionalmaterialtable"
						class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th><sp:message code="label.id" /></th>
								<th><sp:message code="label.additionalmaterial" /></th>
								<th>数量</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="additionalmaterial"
								items="${additionalmateriallist}" varStatus="loop">
								<tr>
									<td><input
										id='additionalsequence<c:out value="${loop.index+1}"/>'
										name="additionalsequence" type="text" value="${loop.index+1}"
										style='width: 100px; padding: 4px;' /></td>
									<td><input
										id='additionalmaterialname<c:out value="${loop.index+1}"/>'
										name="additionalmaterialname" type="text"
										value='<c:out value="${additionalmaterial[0]}"/>'
										style='width: 100px; padding: 4px;' /></td>
									<td><input
										id='additionalmaterialcount<c:out value="${loop.index+1}"/>'
										name="additionalmaterialcount" type="text"
										value='<c:out value="${additionalmaterial[1]}"/>'
										style='width: 100px; padding: 4px;' /></td>
								</tr>
							</c:forEach>
					</table>
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
					<sf:label path="salesman.name" cssClass="col-sm-2 control-label">
						备注
					</sf:label>
					<div class="col-sm-2">
						<sf:textarea path="memo" cols="60" rows="6" />
					</div>
				</div>

				<input id="materialchildrenstring" name="materialchildrenstring"
					type="hidden">
				<input id="additionalmaterialstring" name="additionalmaterialstring"
					type="hidden">
				<div class="form-group">
					<div class="col-sm-offset-3 col-sm-1">
						<button type="submit" onclick="submitorder()"
							class="btn btn-primary">
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
