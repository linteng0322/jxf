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

<title>${sysconf.companyname}</title>

<%@ include file="../includes/jsheader.jsp"%>

<script type="text/javascript">
	//importClass(Packages.com.jxf.oa.entity.MaterialOrder);
	$(document).ready(function() {
		if ($("#materialid").val() == "") {
			$("#cmaterial").addClass("current-menu-item"); //Add "active" class to selected tab  
		} else {
			$("#ordlist").addClass("current-menu-item"); //Add "active" class to selected tab  
		}

		var x = document.getElementsByName("materialtype");
		var i = x.length;
		if (i == 0) {
			addmoreType();
		}
		initleibietables();

	});
	function initleibietables() {
		//首先判断有几种类别，然后加这几种类别的表头
		//在判断每一种类别有几个materialorder，加上表内容
		var materialorderliststring = $(
				'input:hidden[id="materialorderliststring"]').val();
		materialorderlist = materialorderliststring.split(",");
		var totalorderlength = materialorderlist.length;
		for (var i = 0; i < totalorderlength; i++) {
			var materialorder = materialorderlist[i].split(";");
			var leibie = materialorder[0];
			var materialId = materialorder[1];
			var thickness = materialorder[2];
			var color = materialorder[3];
			var length = materialorder[4];
			var materialcount = materialorder[5];

			var x = document.getElementsByName("materialtype");
			var materialtypelength = x.length;//eg: leibie 5: find i=3, then add 2 more type;
			/* if(materialtypelength<leibie){
				for(var y = 0; y < leibie-materialtypelength; y++){
					addmoreType();
				}
			} */
			addElement(leibie, materialId, thickness, color, length,
					materialcount);
		}
	}

	function inputthisrow(typenumber, row, input) {
		var materialstring = input.value;
		var materialparams = materialstring.split(";");
		$('#materialId_' + typenumber + '_' + row).val(materialparams[0]);
		$('#thickness_' + typenumber + '_' + row).val(materialparams[1]);
		$('#color_' + typenumber + '_' + row).val(materialparams[2]);
		$('#length_' + typenumber + '_' + row).val(materialparams[3]);
	}
	function addmultipleElement(typenumber) {
		for (var i = 0; i < 5; i++) {
			addElement(typenumber, "", "", "", "", "");
		}
	}
	function addElement(typenumber, materialId, thickness, color, length,
			materialcount) {
		//should find that table and then find the sequence
		//try one table
		var thistable = $('#searchmaterialtable', document);
		//var thistable = $('#searchmaterialtable'+typenumber, document);
		//document.getElementsByName("searchmaterialtable"+typenumber);
		//var x = document.getElementsByName("sequence");
		//$("input[name="元素名词"]")
		//try continue sequence for different types
		var i = $("input[name='sequence']", thistable).length;
		//var i = $("input[name='sequence_"+typenumber+"']",thistable).length;
		//var i = rows.lentgh;
		//var i = x.length;
		i = i + 1;

		var appendstring = "<tr><td>"
				//try continue sequence for different types
				+ "<input id='sequence_"+typenumber+"_"+i+ "' name='sequence' value=" +i + " style='width: 30px; padding: 4px; border: none; background: transparent;' readonly='readonly'/>"
				//+ "<input id='sequence_"+typenumber+"_"+i+ "' name='sequence_"+typenumber+"' value=" +i + " style='width: 30px; padding: 4px; border: none; background: transparent;' readonly='readonly'/>"
				+ "<input id='identity"+typenumber+"_"+i+ "' type='hidden' name='identity_"+typenumber+"' value='' style='width: 100px; padding: 4px;' />"
				+ "<input id='materialtype_"+typenumber+"_"+i+ "' type='hidden' name='leibie_"+typenumber+"' value='"+typenumber+"' style='width: 100px; padding: 4px;' />"
				+ "</td><td>" + "<input id='materialId_"
				+ typenumber
				+ "_"
				+ i
				+ "' name='materialId_"
				+ typenumber
				+ "' value='"
				+ materialId
				+ "' list='json-datalist' style='padding: 4px; border: none; background: transparent;' readonly='readonly'"
				+ "oninput='inputthisrow("
				+ typenumber
				+ ","
				+ i
				+ ", this)'/>"
				+ "<datalist id='json-datalist'></datalist>"
				+ "</td><td>"
				+ "<input id='thickness_"+typenumber+"_"+i+ "' name='thickness_"+typenumber+"' value='"+thickness+"' style='padding: 4px; border: none; background: transparent;' readonly='readonly' />"
				+ "</td><td>"
				+ "<input id='color_"+typenumber+"_"+i+ "' name='color_"+typenumber+"' value='"+color+"' style='padding: 4px; border: none; background: transparent;' readonly='readonly' />"
				+ "</td><td>"
				+ "<input id='length_"+typenumber+"_"+i+ "' name='length_"+typenumber+"' value='"+length+"' style='padding: 4px; border: none; background: transparent;' readonly='readonly' />"
				+ "</td><td>"
				+ "<input id='materialcount_"+typenumber+"_"+i+ "' name='materialcount_"+typenumber+"' value='"+materialcount+"' style='padding: 4px; border: none; background: transparent;' readonly='readonly' />"
				+ "</td></tr>";
		//try one table		
		$('#searchmaterialtable', document).append(appendstring);
		//$('#searchmaterialtable'+typenumber, document).append(appendstring);
		//document.getElementsByName("searchmaterialtable1").append(appendstring);
	}
	function addmoreType() {

		addmaterialtypetable();
	}

	function addmaterialtypetable() {
		var x = document.getElementsByName("materialtype");
		var i = x.length + 1;
		var appendstring = "<div id='materialtype"+i+"' name='materialtype' class='panel panel-default'>"
				//try one table	
				+ "<table id='searchmaterialtable' class='table table-striped table-bordered table-hover table-condensed' style='font-size:10px'>"
				//+"<table id='searchmaterialtable"+i+"' class='table table-striped table-bordered table-hover table-condensed'>"
				+ "	<thead><tr><th><sp:message code='label.id' /></th>"
				+ "			<th><sp:message code='label.material' /></th>"
				+ "			<th><sp:message code='label.thickness' /></th>"
				+ "			<th><sp:message code='label.color' /></th>"
				+ "			<th><sp:message code='label.length' /></th>"
				+ "			<th><sp:message code='label.count' /></th></tr></thead><tbody></tbody></table>"
				+ "";
		$('#materialtypelist', document).append(appendstring);
	}
</script>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<body class="home">
	<div id="page">
		<div style="width: 100%">
			<ul id="companylogo"
				style="position: relative; top: 30px; bottom: 30px; margin-right: 20px; float: left;">
				<table style="font-size: 40px; text-align: center">
					<tr>
						<td align="center"><c:out value="${sysconf.companyname}"></c:out>配货单</td>
					</tr>
				</table>
			</ul>
		</div>
		<br />
		<div style="float: right; width: 100%;">
			<p>
				<sf:form servletRelativeAction="savecreateorder" method="post"
					modelAttribute="order" cssClass="form-horizontal">

					<sf:errors path="*" cssClass="alert alert-danger" element="div" />
					<sf:hidden id="id" path="id" />
					<sf:hidden id="materialorderliststring"
						path="materialorderliststring" />

					<sp:message code="label.order" />:<c:out value='${order.orderId}'/>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
					<sp:message code="label.customer" />:<c:out value='${order.customer.name}'/>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
					<sp:message code="label.orderdate" />:<c:out value='${order.createdOn}'/>
					<div id="materialtypelist"></div>
					配件
						<table id="additionalmaterialtable" class="table table-striped table-bordered table-hover table-condensed" style=""font-size:10px" >
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
									<td><c:out value="${loop.index+1}" /></td>
									<td><c:out value="${additionalmaterial[0]}" /></td>
									<td><c:out value="${additionalmaterial[1]}" /></td>
								</tr>
							</c:forEach>
					</table>
					<br />
					<sp:message code="label.salesman" />:<c:out value='${order.salesman.name}'/>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
					备注:<c:out value='${order.memo}'/>
					<input id="materialchildrenstring" name="materialchildrenstring"
						type="hidden">
					<input id="additionalmaterialstring"
						name="additionalmaterialstring" type="hidden">
				<br />
				<br />
				<br />
				公司：<c:out value='${sysconf.companyname}'/>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
				电话：<c:out value='${sysconf.phone}'/>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
				地址：<c:out value='${sysconf.address}'/>
				<br />
				&copy; Copyright &copy; All rights reserved.
		</div>


		</sf:form>
	</div>

	<%@ include file="../includes/footer.jsp"%>
</body>
</html>
