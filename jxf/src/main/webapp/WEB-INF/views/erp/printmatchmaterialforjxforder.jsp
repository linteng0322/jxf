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
	$(document).ready(function() {
		$("#allmaterialgroup").addClass("current-menu-item"); //Add "active" class to selected tab  
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
		var materialorderliststring = $('input:hidden[id="materialorderliststring"]').val();
		materialorderlist = materialorderliststring.split(",");
		var totalorderlength = materialorderlist.length;
		for(var i = 0; i< totalorderlength; i++){
			var materialorder = materialorderlist[i].split(";");
			var leibie = materialorder[0];
			var identity = materialorder[1];
			var materialId = materialorder[2];
			var thickness = materialorder[3];
			var color = materialorder[4];
			var length = materialorder[5];
			var materialcount = materialorder[6];
			var pinming = materialorder[7];
			var materialstatus = materialorder[8];
			var missingcount = materialorder[9];
			
			
			
			var x = document.getElementsByName("materialtype");
			var materialtypelength = x.length;//eg: leibie 5: find i=3, then add 2 more type;
			/* if(materialtypelength<leibie){
				for(var y = 0; y < leibie-materialtypelength; y++){
					addmoreType();
				}
			} */
			addElement(leibie, identity, materialId, thickness, color, length, materialcount, pinming, materialstatus,missingcount);
		}
		var pricetitle = ""
			+"<table id='pricetable'  style='border:1px; width: 200px; min-height: 20px; line-height: 14px; text-align: left; border-collapse: collapse;' >"
			+"	<thead><tr><th style='border:1px solid;'>类别</th>"
			+"			<th style='border:1px solid;'>理论重量</th>"
			+"			<th style='border:1px solid;'>实际重量</th>"
			+"			<th style='border:1px solid;'>单价</th></tr></thead><tbody></tbody></table>"
			+"";

		$('#materialpricelist', document).append(pricetitle);
		var pricelist = "";
		var calweightstring = $('input:hidden[id="calweight"]').val();;
		if(calweightstring != "") {
			var calweighttable=calweightstring.split(",");
			for(var row = 0; row < calweighttable.length; row++){
				var thisrow = calweighttable[row].split(";");
				var thisleibie = thisrow[0];
				var sequence = row+1;
				//thisleibie = "<input name='leibie' id='leibie"+sequence+"' value='"+thisleibie+"' style='width: 20px; padding: 4px; border: none; background: transparent;' />";
				var thisleibiecalweight = thisrow[1];
				var thisleibieactweight = (thisrow.length>2)?thisrow[2]:0;
				var thisleibieunitprice = (thisrow.length>3)?thisrow[3]:0;
				//thisleibiecalweight = "<input name='calweightinput' id='calweightinput"+sequence+"' value='"+thisleibiecalweight+"' style='width: 100px; padding: 4px; border: none; background: transparent;' />";
				//var thisactweight = "<input name='actweightinput' id='actweightinput"+sequence+"' value='"+thisleibieactweight+"' style='width: 100px; padding: 4px; border: none; background: transparent;' />";
				//var thisunitprice = "<input name='unitpriceinput' id='unitpriceinput"+sequence+"' value='"+thisleibieunitprice+"' style='width: 100px; padding: 4px; border: none; background: transparent;' />";
				pricelist = "<tr><td style='border:1px solid;'>"
				+thisleibie+"</td><td style='border:1px solid;'>"
				+thisleibiecalweight+"</td><td style='border:1px solid;'>"
				+thisleibieactweight+"</td><td style='border:1px solid;'>"
				+thisleibieunitprice+"</td></tr>";
				$('#pricetable', document).append(pricelist);
			}
		}
	}
	function addElement(typenumber, identity, materialId, thickness, color, length, materialcount, pinming, materialstatus, missingcount, checkboxstatus) {
		//should find that table and then find the sequence
		var thistable = $('#searchmaterialtable', document);
		//document.getElementsByName("searchmaterialtable"+typenumber);
		//var x = document.getElementsByName("sequence");
		//$("input[name="元素名词"]")
		var i = $("input[name='sequence']",thistable).length;
		//var i = rows.lentgh;
		//var i = x.length;
		i = i + 1;
		
		var pricestring="";
		var pricelist = "";
		var calweightstring = $('input:hidden[id="calweight"]').val();;
		if(calweightstring != "") {
			var calweighttable=calweightstring.split(",");
			for(var row = 0; row < calweighttable.length; row++){
				var thisrow = calweighttable[row].split(";");
				var thisleibie = thisrow[0];
				if(thisleibie==typenumber)
				pricestring = (thisrow.length>3)?thisrow[3]:0;
		
			}
		}
		
		
		
		var originalcheckbox = "<input type='checkbox' name='preparetoout' value='"+identity+"'/>";
		var updatedcheckbox = "<input type='checkbox' name='preparetoout' disabled='disabled' checked='checked' />";
		var checkboxstring = (materialstatus!="completed")? originalcheckbox : updatedcheckbox; 
		if(materialstatus == "set") materialstatus = "已匹配";
		if(materialstatus == "completed") materialstatus="出库完成";
		if(materialstatus == "partial") materialstatus="部分出库";
		var originalmisscount = "<input id='missingcount_"+typenumber+"_"+i+ "' type='text' name='outcount' value='"+missingcount+"' style='width: 80px; padding: 4px;' />";
		var updatedmissingcount = "<input id='missingcount_"+typenumber+"_"+i+ "' type='text' name='outcount' value='' style='width: 60px; padding: 4px; border: none; background: transparent;' />";
		var missingcountstring = (missingcount!=0) ? originalmisscount : updatedmissingcount;
		var pinmingred = "";
		if(pinming=="null"){
			pinmingred = "color:red";
			pinming = "无此物料";
		}
		var pinmingstring = "<input id='pinming_"+typenumber+"_"+i+ "' name='pinming_"+typenumber+"' value='"+pinming
							+"' style='width: 60px; padding: 4px; border: none; background: transparent; "+pinmingred+"' />";
		
		var	appendstring = 		"<tr><td>"
								+ "<input id='sequence_"+typenumber+"_"+i+ "' name='sequence' value=" +i + " style='width: 20px; padding: 4px; border: none; background: transparent;'/>"
								+ "<input id='identity"+typenumber+"_"+i+ "' type='hidden' name='identity_"+typenumber+"' value='' style='width: 60px; padding: 4px; border: none; background: transparent;' />"
								+ "<input id='materialtype_"+typenumber+"_"+i+ "' type='hidden' name='leibie_"+typenumber+"' value='"+typenumber+"' style='width: 60px; padding: 4px; border: none; background: transparent;' />"
								+ "</td><td>"
								+ "<input id='materialId_"+typenumber+"_"+i+ "' name='materialId_"+typenumber+"' value='"+materialId+"' list='json-datalist' style='width: 150px; padding: 4px; border: none; background: transparent;'"
								+ "oninput='inputthisrow("+typenumber+","+ i+ ", this)'/>"
								+ "<datalist id='json-datalist'></datalist>"
								+ "</td><td>"
								+ "<input id='thickness_"+typenumber+"_"+i+ "' name='thickness_"+typenumber+"' value='"+thickness+"' style='width: 60px; padding: 4px; border: none; background: transparent;' />"
								+ "</td><td>"
								+ "<input id='color_"+typenumber+"_"+i+ "' name='color_"+typenumber+"' value='"+color+"' style='width: 60px; padding: 4px; border: none; background: transparent;' />"
								+ "</td><td>"
								+ "<input id='length_"+typenumber+"_"+i+ "' name='length_"+typenumber+"' value='"+length+"' style='width: 60px; padding: 4px; border: none; background: transparent;' />"
								+ "</td><td>"
								+ "<input id='materialcount_"+typenumber+"_"+i+ "' name='materialcount_"+typenumber+"' value='"+materialcount+"' style='width: 60px; padding: 4px; border: none; background: transparent;' />"
								+ "</td><td>"
								+ pinmingstring
								/* + "</td><td>"
								+ "<input id='materialstatus_"+typenumber+"_"+i+ "' name='materialstatus_"+typenumber+"' value='"+materialstatus+"' style='width: 60px; padding: 4px; border: none; background: transparent;' />"
								+ "</td><td>"
								+ missingcountstring
								+ "</td><td>"
								+ checkboxstring */
								+ "</td><td>"
								+ pricestring
								+ "</td></tr>";
								
			$('#searchmaterialtable', document).append(appendstring);
			//document.getElementsByName("searchmaterialtable1").append(appendstring);
	}
	function addmoreType() {
		
		addmaterialtypetable();
	}
	function addmaterialtypetable() {
		var x = document.getElementsByName("materialtype");
		var i = x.length+1;
		var appendstring = "<table id='searchmaterialtable' class='table table-striped table-bordered table-hover table-condensed' style='font-size:10px'>"
			+"	<thead><tr><th><sp:message code='label.id' /></th>"
			+"			<th><sp:message code='label.material' /></th>"
			+"			<th><sp:message code='label.thickness' /></th>"
			+"			<th><sp:message code='label.color' /></th>"
			+"			<th><sp:message code='label.length' /></th>"
			+"			<th><sp:message code='label.count' /></th>"
			+"			<th><sp:message code='label.pinming' /></th>"
			+"			<th>单价</th>"
			//+"			<th>欠货数量</th>"
			//+"			<th>出库</th></tr></thead><tbody></tbody></table>"
			+"";
			
			$('#materialtypelist', document).append(appendstring);
	}
	
	function check() {
		if (confirm('确实要出库吗?')) {
			// check all material count set
			var x = document.getElementsByName("materialcount");
			var l = x.length;
			for (var j = 1; j <= l; j++) {
				var materialcount = $('input:text[id="materialcount' + j + '"]')
						.val();
				if (materialcount == "") {
					alert("请编辑此订单，为第" + j + "行物料添加数量。");
					return false;
				}
			}
			// check all material set
			x = document.getElementsByName("searchmaterial");
			l = x.length;
			for (var j = 1; j <= l; j++) {
				var searchmaterial = $(
						'input:hidden[id="searchmaterial' + j + '"]').val();
				if (searchmaterial == "") {
					alert("请编辑此订单，匹配第" + j + "行。");
					return false;
				}
			}
			// check additional material
			x = document.getElementsByName("additionalmaterialcount");
			l = x.length;
			for (var j = 1; j <= l; j++) {
				var searchmaterial = $(
						'input:text[id="additionalmaterialcount' + j + '"]').val();
				if (searchmaterial == "") {
					alert("请编辑此订单，为第" + j + "行配件添加数量。");
					return false;
				}
			}

			return true;
		}
		return false;
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
						<td align="center"><c:out value="${sysconf.companyname}"></c:out>发货单</td>
					</tr>
				</table>
			</ul>
		</div>
		<br />
		<div style="float: right; width: 100%;">
		<p />
			<sf:form servletRelativeAction="jxfordertotransactionout"
				method="post" modelAttribute="order" cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />
				
					<sf:input path="id" type="hidden" maxlength="20"
						cssClass="form-control" />
					<sf:hidden id="materialorderliststring" path="materialorderliststring" />
					<sf:hidden id="calweight" path="calweight" />
					<sp:message code="label.order" />:<c:out value='${order.orderId}'/>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
					<sp:message code="label.customer" />:<c:out value='${order.customer.name}'/>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
					<sp:message code="label.orderdate" />:<c:out value='${order.createdOn}'/>
				<div id="materialtypelist">
				</div>
				配件
				<sf:input path="additionalmaterialstring"
					id="additionalmaterialstring" name="additionalmaterialstring"
					type="hidden" />
					<table id="additionalmaterialtable" style="border:1px; width: 200px; min-height: 20px; line-height: 14px; text-align: left; border-collapse: collapse;" >
						<thead>
							<tr>
								<th style="border:1px solid;"><sp:message code="label.id" /></th>
								<th style="border:1px solid;"><sp:message code="label.additionalmaterial" /></th>
								<th style="border:1px solid;">数量</th>
								<th style="border:1px solid;">单价</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="additionalmaterial"
								items="${additionalmateriallist}" varStatus="loop">
								<tr>
									<td style="border:1px solid; padding: 4px;">${loop.index+1}</td>
									<td style="border:1px solid; padding: 4px;"><c:out value="${additionalmaterial[0]}"/></td>
									<td style="border:1px solid; padding: 4px;"><c:out value="${additionalmaterial[1]}"/></td>
									<td style="border:1px solid; padding: 4px;"><c:out value="${additionalmaterial[2]}"/></td>
								</tr>
							</c:forEach>
					</table>
				<input id="matchmaterial" name="matchmaterial" type="hidden"
					value="abc">
				<p />
				<div id="materialpricelist"></div>
				<p />
				铝材金额:<c:out value='${order.actincome}'/>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
				配件总金额:<c:out value='${order.additionalincome}'/>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
				<sp:message code="label.actweight" />:<c:out value='${order.actweight}'/>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
				汇总金额:<c:out value='${order.totalincome}'/>
				<p />
				<sp:message code="label.salesman" />:<c:out value='${order.salesman.name}'/>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
				物流票号:<c:out value='${order.expressinfo }'/>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
				备注:<c:out value='${order.memo}'/>
				<br />
				<br />
				<br />
				公司：<c:out value='${sysconf.companyname}'/>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
				电话：<c:out value='${sysconf.phone}'/>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
				地址：<c:out value='${sysconf.address}'/>
				<br />
				&copy; Copyright &copy; All rights reserved.
			</sf:form>
	
	
		
		</div>
	</div>
</body>
</html>
