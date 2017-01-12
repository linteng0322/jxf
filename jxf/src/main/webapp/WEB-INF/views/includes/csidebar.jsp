<script type="text/javascript">
$(document).ready(function(){
	 $.ajax({         
         type: "POST",
         dataType : "text",
         url:"${pageContext.request.contextPath}/material/findriskmaterialsize",
         //data:"",
         contentType: "text/html; charset=utf-8",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
             //alert(XMLHttpRequest.status);
             //alert(XMLHttpRequest.readyState);
             //alert(textStatus);
             alert("Retrieve material size error!");
         },
         success: function(data) {
        	 if(data>0){
        	 $("#msize").html("("+data+")");
        	 }
         }
     });
});
</script>
<ul class="dropdown-menu" style="display: block !important;">
	<sec:authorize
		ifAnyGranted="ROLE_ADMIN,ROLE_SYSUSER,ROLE_SALES,ROLE_FINANCE,ROLE_PROJECTMANAGER">
		<li><a href="<c:url value="/jxforder/out"/>"> <sp:message
					code="label.orderout" />
		</a></li>
		<li><a href="<c:url value="/jxforder/alljxforder"/>"> <sp:message
					code="label.allorder" />
		</a></li>
		<li><a href="<c:url value="/jxforder/searchjxforder"/>"> <sp:message
					code="label.orderreport" />
		</a></li>
		<%-- <li><a href="<c:url value="/transaction/batchout"/>"> <sp:message
					code="label.transactionsout" />
		</a></li> --%>
		<li><a href="<c:url value="/transaction/batchin"/>"> <sp:message
					code="label.transactionin" />
		</a></li>
		<li id="transactionsearch"><a
			href="<c:url value="/transaction/alltransactionlist"/>"> <sp:message
					code="label.transactionsearch" />
		</a></li>
		<%-- <li><a href="<c:url value="/transaction/out"/>"> <sp:message
					code="label.transactionout" />
		</a></li>
		<li id="transactionin"><a href="<c:url value="/transaction/in"/>">
				<sp:message code="label.transactionin" />
		</a></li> --%>
		<li id="materiallist"><a
			href="<c:url value="/material/allmateriallist"/>"> <sp:message
					code="label.materialmaintain" />
		</a></li>
		<li id="materiallist"><a
			href="<c:url value="/material/searchriskmaterial"/>"> <sp:message
					code="label.materialrisk" />
					<label style="color:red" id="msize"></label>
		</a></li>
		<li id="materialgrouplist"><a
			href="<c:url value="/materialgroup/allmaterialgrouplist"/>"> <sp:message
					code="label.materialgroup" />
		</a></li>
		<li id="materiallist"><a
			href="<c:url value="/customer/allcustomerlist"/>"> <sp:message
					code="label.clientorfactory" />
		</a></li>
		<li id="allsamesman"><a
			href="<c:url value="/salesman/allsalesman"/>"> <sp:message
					code="label.salesman" />
		</a></li>
	</sec:authorize>
</ul>