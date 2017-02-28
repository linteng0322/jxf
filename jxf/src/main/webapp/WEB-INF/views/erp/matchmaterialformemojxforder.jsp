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
		$("#allmaterialgroup").addClass("current-menu-item"); //Add "active" class to selected tab  
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
			if(materialtypelength<leibie){
				for(var y = 0; y < leibie-materialtypelength; y++){
					addmoreType();
				}
			}
			addElement(leibie, identity, materialId, thickness, color, length, materialcount, pinming, materialstatus,missingcount);
		}
		var pricetitle = ""
			+"<table id='pricetable' class='table table-striped table-bordered table-hover table-condensed'>"
			+"	<thead><tr><th>类别</th>"
			+"			<th>理论重量</th>"
			+"			<th>实际重量</th>"
			+"			<th>单价</th></tr></thead><tbody></tbody></table>"
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
				thisleibie = "<input name='pricesequence' type='hidden' value='"+sequence+"' /><input name='leibie' id='leibie"+sequence+"' value='"+thisleibie+"' style='width: 20px; padding: 4px; border: none; background: transparent;' />";
				var thisleibiecalweight = thisrow[1];
				var thisleibieactweight = (thisrow.length>2)?thisrow[2]:0;
				var thisleibieunitprice = (thisrow.length>3)?thisrow[3]:0;
				thisleibiecalweight = "<input name='calweightinput' id='calweightinput"+sequence+"' value='"+thisleibiecalweight+"' style='width: 100px; padding: 4px; border: none; background: transparent;' />";
				var thisactweight = "<input name='actweightinput' id='actweightinput"+sequence+"' value='"+thisleibieactweight+"' style='width: 100px; ' onkeyup='calcuincome()' />";
				var thisunitprice = "<input name='unitpriceinput' id='unitpriceinput"+sequence+"' value='"+thisleibieunitprice+"' style='width: 100px; ' onkeyup='calcuincome()' />";
				pricelist = "<tr><td>"+thisleibie+"</td><td>"+thisleibiecalweight+"</td><td>"+thisactweight+"</td><td>"+thisunitprice+"</td></tr>";
				$('#pricetable', document).append(pricelist);
			}
		}
	}
	function addElement(typenumber, identity, materialId, thickness, color, length, materialcount, pinming, materialstatus, missingcount, checkboxstatus) {
		//should find that table and then find the sequence
		var thistable = $('#searchmaterialtable'+typenumber, document);
		//document.getElementsByName("searchmaterialtable"+typenumber);
		//var x = document.getElementsByName("sequence");
		//$("input[name="元素名词"]")
		var i = $("input[name='sequence_"+typenumber+"']",thistable).length;
		//var i = rows.lentgh;
		//var i = x.length;
		i = i + 1;
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
								+ "<input id='sequence_"+typenumber+"_"+i+ "' name='sequence_"+typenumber+"' value=" +i + " style='width: 20px; padding: 4px; border: none; background: transparent;'/>"
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
		var appendstring = "<span>类别"+i+"</span><p>"
			+"<div id='materialtype"+i+"' name='materialtype' class='panel panel-default'>"
			+"<table id='searchmaterialtable"+i+"' class='table table-striped table-bordered table-hover table-condensed'>"
			+"	<thead><tr><th><sp:message code='label.id' /></th>"
			+"			<th><sp:message code='label.material' /></th>"
			+"			<th><sp:message code='label.thickness' /></th>"
			+"			<th><sp:message code='label.color' /></th>"
			+"			<th><sp:message code='label.length' /></th>"
			+"			<th><sp:message code='label.count' /></th>"
			+"			<th><sp:message code='label.pinming' /></th>"
			+"</tr></thead><tbody></tbody></table>";
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
	function checkenoughstock() {
		$
				.ajax({
					type : "POST",
					dataType : "text",
					url : "${pageContext.request.contextPath}/jxforder/checkallenoughstock?identity=${order.id}",
					//data:"",
					contentType : "text/html; charset=utf-8",
					error : function(XMLHttpRequest, textStatus, errorThrown) {
						//alert(XMLHttpRequest.status);
						//alert(XMLHttpRequest.readyState);
						//alert(textStatus);
						alert(1);
					},
					success : function(data) {
						if (data != "true") {
							alert(data + "库存不够。");
							return false;
						}
					}
				});
		return true;
	}
	function calcuincome() {
		//var actweight = $('input:text[id="actweight"]').val();
		var unitprice = $('input:text[id="unitprice"]').val();
		var additionalincome = 0;
		var x = document.getElementsByName("additionalsequence");
		var i = x.length;
		var flag = "";
		var additionalmaterialstring = "";
		for (var j = 1; j <= i; j++) {
			var additionalmaterialname = $(
					'input:text[id="additionalmaterialname' + j + '"]').val();
			var additionalmaterialcount = $(
					'input:text[id="additionalmaterialcount' + j + '"]').val();
			var additionalmaterialunitprice = $(
					'input:text[id="additionalmaterialunitprice' + j + '"]')
					.val();

			if (additionalmaterialname != "") {
				if (flag == "") {
					additionalmaterialstring = additionalmaterialname + ";"
							+ additionalmaterialcount + ";"
							+ additionalmaterialunitprice;
					flag = "has";
				} else {
					additionalmaterialstring = additionalmaterialstring + ","
							+ additionalmaterialname + ";"
							+ additionalmaterialcount + ";"
							+ additionalmaterialunitprice;
				}
				additionalincome = additionalincome + additionalmaterialcount
						* additionalmaterialunitprice;
			}
		}
		var totalactweight = 0;
		var materialincome = 0;
		var calweightstring = "";
		var pricesequencelist = document.getElementsByName("pricesequence");
		var leibielength = pricesequencelist.length;
		for(var j = 1; j <= leibielength; j++){
			var thisleibiestring = $('input:text[id="leibie' + j + '"]').val();
			var thiscalweightstring = $('input:text[id="calweightinput' + j + '"]').val();
			var thisactweightstring = $('input:text[id="actweightinput' + j + '"]').val();
			var thisunitpricestring = $('input:text[id="unitpriceinput' + j + '"]').val();
			totalactweight = totalactweight + thisactweightstring * 1; 
			materialincome = materialincome + thisactweightstring * thisunitpricestring;
			if(j==1) calweightstring = thisleibiestring + ";" + thiscalweightstring + ";" + thisactweightstring + ";" + thisunitpricestring;
			else calweightstring = calweightstring + "," + thisleibiestring + ";" + thiscalweightstring + ";" + thisactweightstring + ";" + thisunitpricestring;
		}
		$('#calweight').val(calweightstring);
		$('#actweight').val(totalactweight);
		$('#additionalmaterialstring').val(additionalmaterialstring);
		$('#actincome').val(materialincome);
		$("#additionalincome").val(additionalincome);
		//$('#totalincome').val(actweight * unitprice + additionalincome);
		$('#totalincome').val(additionalincome+materialincome*1);
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
			<sf:form servletRelativeAction="memojxfordertotransactionout"
				method="post" modelAttribute="order" cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />
				<div class="panel panel-default">
					<sf:input path="id" type="hidden" maxlength="20"
						cssClass="form-control" />
					<sf:hidden id="materialorderliststring" path="materialorderliststring" />
					<sf:hidden id="calweight" path="calweight" />
					<div class="panel-heading">
						<sp:message code="label.checkstock" />
					</div>

					<div class="form-group">
						<sf:label path="orderId" cssClass="col-sm-2 control-label">
							<sp:message code="label.order" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="orderId" maxlength="20" cssClass="form-control"
								readonly="true" />
						</div>
						<sf:label path="customer.name" cssClass="col-sm-2 control-label">
							<sp:message code="label.customer" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="customer.name" maxlength="20"
								cssClass="form-control" readonly="true" />
						</div>
					</div>
				</div>
				<div class="panel panel-default">
				 <div id="materialtypelist">
				 </div>
				</div>
				<sf:input path="additionalmaterialstring"
					id="additionalmaterialstring" name="additionalmaterialstring"
					type="hidden" />
				<div class="panel panel-default">
					<table id="additionalmaterialtable"
						class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th><sp:message code="label.id" /></th>
								<th><sp:message code="label.additionalmaterial" /></th>
								<th>数量</th>
								<th>单价</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="additionalmaterial"
								items="${additionalmateriallist}" varStatus="loop">
								<tr>
									<td><input
										id='additionalsequence<c:out value="${loop.index+1}"/>'
										name="additionalsequence" value="${loop.index+1}"
										style='width: 20px; padding: 4px; border: none; background: transparent;'
										readonly="readonly" /></td>
									<td><input
										id='additionalmaterialname<c:out value="${loop.index+1}"/>'
										name="additionalmaterialname" 
										value='<c:out value="${additionalmaterial[0]}"/>'
										style='width: 100px; padding: 4px; border: none; background: transparent;'
										readonly="readonly" /></td>
									<td><input
										id='additionalmaterialcount<c:out value="${loop.index+1}"/>'
										name="additionalmaterialcount" 
										value='<c:out value="${additionalmaterial[1]}"/>'
										style='width: 100px; padding: 4px; border: none; background: transparent;'
										readonly="readonly" /></td>
									<td><input
										id='additionalmaterialunitprice<c:out value="${loop.index+1}"/>'
										name="additionalmaterialunitprice" type="text"
										required="required"
										value='<c:out value="${additionalmaterial[2]}"/>'
										onkeyup='calcuincome()' style='width: 100px; padding: 4px; border: none; background: transparent;' /></td>
								</tr>
							</c:forEach>
					</table>
				</div>
				<input id="matchmaterial" name="matchmaterial" type="hidden"
					value="abc">
				
				<div class="panel panel-default">
					<div id="materialpricelist">
				 	</div>
				</div>
				<div class="form-group">
					<sf:label path="salesman.name" cssClass="col-sm-2 control-label">
						备注
					</sf:label>
					<div class="col-sm-2">
						<sf:textarea path="memo" cols="60" rows="3" />
					</div>
				</div>
				<div class="form-group">
					<sf:label path="expressinfo" cssClass="col-sm-2 control-label">
						物流票号
					</sf:label>
					<div class="col-sm-2">
						<sf:textarea path="expressinfo" cols="60" rows="1" />
					</div>
				</div>
				<div class="form-group">
					<sf:label path="actincome" cssClass="col-sm-2 control-label">
						铝材金额
					</sf:label>
					<div class="col-sm-2">
						<sf:input path="actincome" required="true" maxlength="20"
							cssClass="form-control" />
					</div>
					<sf:label path="additionalincome" cssClass="col-sm-2 control-label">
						配件总金额
					</sf:label>
					<div class="col-sm-2">
						<sf:input path="additionalincome" maxlength="20"
							cssClass="form-control" />
					</div>
				</div>
				<div class="from-group">
					<sf:label path="actweight" cssClass="col-sm-2 control-label">
						<sp:message code="label.actweight" />
					</sf:label>
					<div class="col-sm-2">
						<sf:input id="actweight" path="actweight" required="true"
							onkeyup='calcuincome()' maxlength="20" cssClass="form-control" />
					</div>
					<sf:label path="totalincome" cssClass="col-sm-2 control-label">
						汇总金额
					</sf:label>
					<div class="col-sm-2">
						<sf:input path="totalincome" maxlength="20"
							cssClass="form-control" />
					</div>
				
					<div class="col-sm-2 control-label">
						<div class="checkbox">
							<label> <sf:checkbox path="ispaid" /> <sp:message
									code="label.payment" />
							</label>
						</div>
					</div>
				</div>
				<div class="form-group">
					<div class="col-md-offset-2 col-sm-1">
						<button type="submit" class="btn btn-primary">保存</button>
					</div>

					<div class="col-md-offset-2 col-sm-1">
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
