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
		initleibietables();
		setcustomerlist();
		setlist();
		
		var x = document.getElementsByName("materialtype");
		var i = x.length;
		if(i==0){
			addmoreType();
		}

	});
	function initleibietables() {
		//首先判断有几种类别，然后加这几种类别的表头
		//在判断每一种类别有几个materialorder，加上表内容
		var materialorderliststring = $('input:hidden[id="materialorderliststring"]').val();
		materialorderlist = materialorderliststring.split(",");
		var totalorderlength = materialorderlist.length;
		for(var i = 0; i< totalorderlength; i++){
			var materialorder = materialorderlist[i].split(";");
			var leibie = materialorder[0];
			var materialId = materialorder[1];
			var thickness = materialorder[2];
			var color = materialorder[3];
			var length = materialorder[4];
			var materialcount = materialorder[5];
			
			var x = document.getElementsByName("materialtype");
			var materialtypelength = x.length;//eg: leibie 5: find i=3, then add 2 more type;
			if(materialtypelength<leibie){
				for(var y = 0; y < leibie-materialtypelength; y++){
					addmoreType();
				}
			}
			addElement(leibie, materialId, thickness, color, length, materialcount);
		}
	}
	function setcustomerlist() {
		$.ajax({
			type : "POST",
			dataType : "text",
			url : "${pageContext.request.contextPath}/customer/getallcustomer",
			//data:"",
			contentType : "text/html; charset=utf-8",
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				alert("出错了，请重试！");
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

	function inputthisrow(typenumber, row, input) {
		var materialstring = input.value;
		var materialparams = materialstring.split(";");
		$('#materialId_'+ typenumber+'_'+ row).val(materialparams[0]);
		$('#thickness_' + typenumber+'_'+ row).val(materialparams[1]);
		$('#color_' + typenumber+'_'+ row).val(materialparams[2]);
		$('#length_' + typenumber+'_'+ row).val(materialparams[3]);
	}
	function addmultipleElement(typenumber) {
		for (var i = 0; i < 5; i++) {
			addElement(typenumber, "","","","","");
		}
	}
	function addElement(typenumber, materialId, thickness, color, length, materialcount) {
		//should find that table and then find the sequence
		var thistable = $('#searchmaterialtable'+typenumber, document);
		//document.getElementsByName("searchmaterialtable"+typenumber);
		//var x = document.getElementsByName("sequence");
		//$("input[name="元素名词"]")
		var i = $("input[name='sequence_"+typenumber+"']",thistable).length;
		//var i = rows.lentgh;
		//var i = x.length;
		i = i + 1;
		
		var	appendstring = 		"<tr><td>"
								+ "<input id='sequence_"+typenumber+"_"+i+ "' name='sequence_"+typenumber+"' value=" +i + " style='width: 30px; padding: 4px; border: none; background: transparent;' readonly='readonly'/>"
								+ "<input id='identity"+typenumber+"_"+i+ "' type='hidden' name='identity_"+typenumber+"' value='' style='width: 100px; padding: 4px;' />"
								+ "<input id='materialtype_"+typenumber+"_"+i+ "' type='hidden' name='leibie_"+typenumber+"' value='"+typenumber+"' style='width: 100px; padding: 4px;' />"
								+ "</td><td>"
								+ "<input id='materialId_"+typenumber+"_"+i+ "' type='text' name='materialId_"+typenumber+"' value='"+materialId+"' list='json-datalist' style='width: 280px; padding: 4px; text-transform:uppercase;'"
								+ "oninput='inputthisrow("+typenumber+","+ i+ ", this)'/>"
								+ "<datalist id='json-datalist'></datalist>"
								+ "</td><td>"
								+ "<input id='thickness_"+typenumber+"_"+i+ "' type='text' name='thickness_"+typenumber+"' value='"+thickness+"' style='width: 100px; padding: 4px;' />"
								+ "</td><td>"
								+ "<input id='color_"+typenumber+"_"+i+ "' type='text' name='color_"+typenumber+"' value='"+color+"' style='width: 100px; padding: 4px;' />"
								+ "</td><td>"
								+ "<input id='length_"+typenumber+"_"+i+ "' type='text' name='length_"+typenumber+"' value='"+length+"' style='width: 100px; padding: 4px;' />"
								+ "</td><td>"
								+ "<input id='materialcount_"+typenumber+"_"+i+ "' type='text' name='materialcount_"+typenumber+"' value='"+materialcount+"' style='width: 100px; padding: 4px;' />"
								+ "</td></tr>";
								
			$('#searchmaterialtable'+typenumber, document).append(appendstring);
			//document.getElementsByName("searchmaterialtable1").append(appendstring);
	}
	function addmoreType() {
		
		addmaterialtypetable();
	}
	
	function addmaterialtypetable() {
		var x = document.getElementsByName("materialtype");
		var i = x.length+1;
		var appendstring = "<a onclick='addmultipleElement("+i+")' title='Register'> <span class='glyphicon glyphicon-plus' >类别"+i+"</span></a><p>"
			+"<div id='materialtype"+i+"' name='materialtype' class='panel panel-default'>"
			+"<table id='searchmaterialtable"+i+"' class='table table-striped table-bordered table-hover table-condensed'>"
			+"	<thead><tr><th><sp:message code='label.id' /></th>"
			+"			<th><sp:message code='label.material' /></th>"
			+"			<th><sp:message code='label.thickness' /></th>"
			+"			<th><sp:message code='label.color' /></th>"
			+"			<th><sp:message code='label.length' /></th>"
			+"			<th><sp:message code='label.count' /></th></tr></thead><tbody></tbody></table>"
			+"";
			$('#materialtypelist', document).append(appendstring);
	}
	function addmultipleadditionalmaterial() {
		for(var y = 0; y < 5; y++){
			addadditionalmaterial();
		}
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
								+ " name='additionalsequence' value=" +i + " style='width: 30px; padding: 4px; border: none; background: transparent;' />"
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
		//共i种类型
		var materialtypelements = document.getElementsByName("materialtype");
		var typelength = materialtypelements.length;
		var appendstring;
		var flag = "";
		//每一种类型，分别添加
		for(var type = 1; type <= typelength; type ++){
			//里面写添加到materialchildstring，逐个找到类型，然后逐个找到id，在添加。每一种类型她们每个字段id应该是：thickness_type_id 
			//找到type=1，2，3的各种表格长度var x = document.getElementsByName("sequence");
		//var i = x.length;
			var materialtableelements = document.getElementsByName("sequence_"+type);
			var materialtablelength = materialtableelements.length;
			for(var l = 1; l<= materialtablelength; l++){
				//var elementid = $('input[name="sequence_'+type+'_'+l+'"]',document).val();
				var elementid = "identity_"+type+"_"+l;
				var identity = $('input:hidden[id='+elementid+']').val();
				elementid = "materialId_"+type+"_"+l;//materialorder materialId
				var materialId = $('input:text[id="' + elementid + '"]').val();
				elementid = "thickness_"+type+"_"+l;
				var thickness = $('input:text[id="' + elementid + '"]').val();
				elementid = "color_"+type+"_"+l;
				var color = $('input:text[id="' + elementid + '"]').val();
				elementid = "length_"+type+"_"+l;
				var length = $('input:text[id="' + elementid + '"]').val();
				elementid = "materialcount_"+type+"_"+l;
				var materialcount = $('input:text[id="' + elementid + '"]').val();
				if (materialId != "") {
					if (flag == "") {
						appendstring = identity + ";" + type + ";" + materialId + ";"
								+ thickness + ";" + color + ";" + length + ";"
								+ materialcount;
						flag = "has";
					} else {
						appendstring = appendstring + "," + identity + ";" + type + ";"
								+ materialId + ";" + thickness + ";" + color + ";"
								+ length + ";" + materialcount;
					}
				}
			}
		}
		
		
		/* var appendstring;
		var additionalmaterialstring;
		var x = document.getElementsByName("sequence");
		var i = x.length;
		var materialorderstring;
		var flag = "";
		for (var j = 1; j <= i; j++) {
			var elementid = $("input[name='sequence']",materialelement).val();
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
		} */
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
	function printorder(){
		var orderid = $('input:hidden[id="id"]').val();
		if(orderid=="")
			alert("订单无效");
		else{
			window.location.href="/jxf/jxforder/printjxforder?id="+orderid;
		}
		//javascript:location='<c:url value="/jxforder/printjxforder?id=${order.id}" />'
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
				<sf:hidden id="materialorderliststring" path="materialorderliststring" />
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
				</div>
				<datalist id="json-datalist">
				</datalist>
				<a onclick="addmoreType()" title="Register"> <span
					class="glyphicon glyphicon-plus">添加新类别</span>
				</a>
				<div id="materialtypelist">
				</div>
				
				<a onclick="addmultipleadditionalmaterial()" title="Register"> <span
					class="glyphicon glyphicon-plus"><sp:message code="label.additionalmaterial" /></span>
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
										name="additionalsequence" value="${loop.index+1}"
										style='width: 30px; padding: 4px; border: none; background: transparent;' /></td>
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
					<sf:label path="memo" cssClass="col-sm-2 control-label">
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
					
					<div class="col-md-offset-3 col-sm-1">
						<button type="button" class="btn btn-default"
							onclick="printorder()">
							<sp:message code="label.print" />
						</button>
					</div>
				</div>
			</sf:form>

		</div>
	</div>

	<%@ include file="../includes/footer.jsp"%>
</body>
</html>
