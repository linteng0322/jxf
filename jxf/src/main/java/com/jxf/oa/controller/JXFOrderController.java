package com.jxf.oa.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.Customer;
import com.jxf.oa.entity.JXFOrder;
import com.jxf.oa.entity.Material;
import com.jxf.oa.entity.MaterialGroup;
import com.jxf.oa.entity.MaterialOrder;
import com.jxf.oa.entity.Salesman;
import com.jxf.oa.entity.Transaction;
import com.jxf.oa.entity.User;
import com.jxf.oa.services.CustomerService;
import com.jxf.oa.services.JXFOrderService;
import com.jxf.oa.services.MaterialGroupService;
import com.jxf.oa.services.MaterialOrderService;
import com.jxf.oa.services.MaterialService;
import com.jxf.oa.services.SalesmanService;
import com.jxf.oa.services.TransactionService;
import com.jxf.oa.services.UserService;

@Controller
@RequestMapping("/jxforder")
public class JXFOrderController extends BaseController {
	@Autowired
	protected JXFOrderService jxforderService;

	@Autowired
	protected CustomerService customerService;

	@Autowired
	protected MaterialService materialService;

	@Autowired
	protected TransactionService transactionService;

	@Autowired
	protected MaterialGroupService materialgroupService;

	@Autowired
	protected MaterialOrderService materialorderService;

	@Autowired
	protected UserService userService;

	@Autowired
	protected SalesmanService salesmanService;

	@RequestMapping("/alljxforder")
	public String findAlloutOrder(Model model, @RequestParam(required = false, defaultValue = "1") Integer page) {
		String TIME_FORMAT = "yyyyMMddHHmmssSSS";
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		SimpleDateFormat sf = new SimpleDateFormat(TIME_FORMAT);
		Page<JXFOrder> jxforderlist = jxforderService.findAllJxfOrder(page, getPageSize(), user.getId());
		model.addAttribute("page", jxforderlist);
		model.addAttribute("order", new JXFOrder());
		return "erp/alljxforder";
	}

	@RequestMapping("/searchjxforder")
	public String searchjxforder(Model model, @Valid @ModelAttribute JXFOrder order, Errors errors) {
		String TIME_FORMAT = "yyyyMMddHHmmssSSS";
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		SimpleDateFormat sf = new SimpleDateFormat(TIME_FORMAT);
		List<JXFOrder> jxforderlist = jxforderService.findJxfOrderListByExample(order, user.getId());

		//Double listcalweight = 0.0;
		Double listactweight = 0.0;
		Double listtotalincome = 0.0;
		for (int i = 0; i < jxforderlist.size(); i++) {
			JXFOrder o = jxforderlist.get(i);
			//if (o.getCalweight() != null)
				//listcalweight = listcalweight + o.getCalweight();
			if (o.getActweight() != null)
				listactweight = listactweight + o.getActweight();
			if (o.getTotalincome() != null)
				listtotalincome = listtotalincome + o.getTotalincome();
		}
		//model.addAttribute("listcalweight", listcalweight);
		model.addAttribute("listactweight", listactweight);
		model.addAttribute("listtotalincome", listtotalincome);
		model.addAttribute("fromdate", "");
		model.addAttribute("todate", new Date());
		model.addAttribute("list", jxforderlist);
		model.addAttribute("jxforder", order);
		return "erp/searchjxforder";
	}

	@RequestMapping("/out")
	public String addoutOrder(Model model, @Valid @ModelAttribute JXFOrder order, Errors errors) {
		String TIME_FORMAT = "yyyyMMddHHmmssSSS";
		SimpleDateFormat sf = new SimpleDateFormat(TIME_FORMAT);
		String orderId = sf.format(new Date());
		order.setOrderId(orderId);
		ArrayList<MaterialOrder> list = new ArrayList();
		MaterialOrder mo = new MaterialOrder();
		mo.setOrderMaterialId("Corder001a");
		list.add(mo);
		model.addAttribute("order", order);
		return "erp/jxforder";
	}

	// use this for new and save
	@RequestMapping("/savecreateorder")
	public String savecreateOrder(Model model, @Valid @ModelAttribute JXFOrder order, String materialchildrenstring,
			Errors errors) {

		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;

		String custstring = order.getCustomer().getName();
		Customer trycustomer = new Customer();
		trycustomer.setName(custstring);
		List<Customer> customers = customerService.findAllByExample(trycustomer);
		if (customers != null && customers.size() > 0)
			trycustomer = customers.get(0);
		else {
			// create customer
			customerService.save(trycustomer);
		}
		order.setCustomer(trycustomer);
		Integer salesmanid = null;
		JXFOrder workingorder = null;
		// check whether order exist, if no save, else update.
		if (order.getId() == null) {
			order.setCreatedBy(user);
			order.setUpdatedBy(user);
			order.setCreatedOn(new Date());
			order.setUpdatedOn(new Date());
			if (order.getSalesman() != null && order.getSalesman().getId() != null)
				order.setSalesman(new Salesman(order.getSalesman().getId()));
			else
				order.setSalesman(null);
			order.setIspaid(false);
			jxforderService.save(order);
		}

		workingorder = jxforderService.findById(JXFOrder.class, order.getId());

		// clear original children list
		MaterialOrder motmp = new MaterialOrder();
		motmp.setJxforderid(workingorder.getId());

		List<MaterialOrder> originalmaterialorderlist = materialorderService.findAllByExample(motmp);
		// workingorder.getMaterialorderlist();
		Iterator<MaterialOrder> it = originalmaterialorderlist.iterator();
		while (it.hasNext()) {
			MaterialOrder mo = it.next();
			materialorderService.delete(mo);
		}

		workingorder.setMaterialorderlist(null);
		jxforderService.update(workingorder);
		if (order.getSalesman() != null && order.getSalesman().getId() != null) {
			salesmanid = order.getSalesman().getId();
			Salesman salesman = salesmanService.findById(Salesman.class, salesmanid);
			workingorder.setSalesman(salesman);
		} else {
			workingorder.setSalesman(null);
		}
		workingorder.setAdditionalmaterialstring(order.getAdditionalmaterialstring());
		workingorder.setAdditionalincome(order.getAdditionalincome());
		workingorder.setMemo(order.getMemo());
		workingorder.setExpressinfo(order.getExpressinfo());
		ArrayList<MaterialOrder> list = new ArrayList();
		// List <MaterialOrder>materialorderlist = order.getMaterialorderlist();
		if (materialchildrenstring != null && materialchildrenstring != "") {// 拼接字符串，包含，id,
																				// ordermaterialId,
																				// orderThickness,
																				// orderColor,
																				// orderLength,
																				// orderCount
			String[] ordermaterials = materialchildrenstring.split(",");// 有效materials
			for (int i = 0; i < ordermaterials.length; i++) {
				String materialstring = ordermaterials[i];
				if (materialstring != null && materialstring != "") {
					MaterialOrder mo = new MaterialOrder();
					String materialparams[] = materialstring.split(";");// 根据分隔符，拿到每一个material的各个字段值
					if (materialparams != null && materialparams.length > 0) {
						String materialid = materialparams[2];// ordermaterialId
						if (materialid != null && materialid != "") {
							mo.setOrderMaterialId(materialid.toUpperCase());
							String idstring = materialparams[0];// identity, if
																// identity
																// exists,
																// update; else
																// save this
																// material
							String materialtypestring = null;
							materialtypestring = materialparams[1]; // materialtype
							
							String thicknessstring = null;
							if (materialparams.length > 3) {
								thicknessstring = materialparams[3];// orderThickness
							}
							String colorstring = null;
							if (materialparams.length > 4) {
								colorstring = materialparams[4];// orderColor
							}
							String lengthstring = null;
							if (materialparams.length > 5) {
								lengthstring = materialparams[5];// orderLength
							}
							String countstring = null;
							if (materialparams.length > 6) {
								countstring = materialparams[6];// orderCount
							}
							Double thickness = null;
							if (thicknessstring != null && thicknessstring.length() > 0)
								thickness = Double.parseDouble(thicknessstring);
							Double length = null;
							if (lengthstring != null && lengthstring.length() > 0)
								length = Double.parseDouble(lengthstring);
							Integer count = null;
							if (countstring != null && countstring.length() > 0)
								count = Integer.parseInt(countstring);
							mo.setLeibie(materialtypestring);
							mo.setOrderThickness(thickness);
							mo.setOrderColor(colorstring);
							mo.setOrderLength(length);
							mo.setOrderCount(count);
							mo.setMissingcount(count);
							mo.setJxforderid(workingorder.getId());
							mo.setMaterialstatus("draft");
							mo.setUpdatedBy(user);
							mo.setUpdatedOn(new Date());
							// check material exist in db: material/material
							// group
							Object o = getmaterial(mo);

							if (o != null && o instanceof Material) {
								Material m = (Material) o;
								mo.setType("material");
								mo.setMormgidentity(m.getId());
								mo.setOrderPinming(m.getPinming());
								mo.setMaterialWeight(m.getLength() * m.getWeight());
								mo.setMaterialstatus("set");
							} else if (o != null && o instanceof MaterialGroup) {
								MaterialGroup mg = (MaterialGroup) o;
								mo.setType("materialgroup");
								mo.setMormgidentity(mg.getId());
								mo.setOrderPinming(mg.getPinming());
								List<Material> materials = getMaterialsfromGroup(mg);
								Double ordermaterialweight = 0.0;
								Iterator<Material> iterator = materials.iterator();
								while (iterator.hasNext()) {
									Material m = iterator.next();
									ordermaterialweight = ordermaterialweight + m.getLength() * m.getWeight();
								}
								mo.setMaterialWeight(ordermaterialweight);
								mo.setMaterialstatus("set");
							}
							// 当这个无聊已经有的时候update它。但是有时候这个物料会被重新设置成别的物料，
							// 所以最好的办法是删掉以前的那些绑定物料，全部根据订单，重新生成。这样的话，加入订单已经走到发货阶段时会有问题。
							// balance一下，物料一旦走到发货就不再允许更改，只能新建订单

							mo.setCreatedBy(user);
							mo.setCreatedOn(new Date());
							materialorderService.save(mo);

							list.add(mo);
						}
					}
				}
			}
			String calWeight = "";
			// set calculated weight 区分不同类型算calcuweight，
			//首先算出一共多少种类型，还是不需要算类型，直接往一个数组里面设置，比如type=1的weight叠加起来，直到所有materialorder便利结束。用Hashmap？
			HashMap<String, Double> hm = new HashMap();
			for (int i = 0; i < list.size(); i++) {
				// find the calculated weight;
				MaterialOrder mo = list.get(i);
				
				
				Double mWeight = 0.0;
				if (mo.getMaterialWeight() != null && mo.getOrderCount() != null) {
					mWeight = mo.getMaterialWeight() * mo.getOrderCount();
				}
				String leibie = mo.getLeibie();
				if(hm.get(leibie)==null){
					hm.put(leibie, (double) 0);
				}
				hm.put(leibie, hm.get(leibie)+mWeight);
				
			}
//			for (int i = 1; i<=hm.keySet().size(); i++){
//				Object key = hm.keySet()[i];
//				if(i==1)
//					calWeight = hm.get(i).toString();
//				else
//					calWeight = calWeight + "," + hm.get(i);
//			}
			
			Iterator iterator = hm.keySet().iterator();                
            while (iterator.hasNext()) {    
             Object key = iterator.next();
             if(calWeight.equals(""))
            	 calWeight = key+";"+hm.get(key).toString();   
             else
            	 calWeight += ","+key+";"+hm.get(key).toString();
            } 
			workingorder.setCalweight(calWeight);
		}
		// check whether allset

		// 所有物料全部匹配，才发货
		workingorder.setJxforderstatus("draft");
		for (int i = 0; i < list.size(); i++) {
			MaterialOrder mo = list.get(i);
			if (mo.getMaterialstatus() != null && mo.getMaterialstatus().equals("draft")) {
				workingorder.setJxforderstatus("draft");
				break;
			} else {
				if (i == list.size() - 1)
					workingorder.setJxforderstatus("allset");
			}
		}
		// order.setMaterialorderlist(list);
		workingorder.setUpdatedBy(user);
		workingorder.setUpdatedOn(new Date());
		jxforderService.update(workingorder);
		model.addAttribute("order", workingorder);
		return "redirect:/jxforder/alljxforder";
	}

	private Object getmaterial(MaterialOrder mo) {
		// TODO Auto-generated method stub
		// "select bank from BankAccount bank where
		// bank.user.id='"+user.getId()+"'";
		// String hql = "from Material where materialId
		// ='"+mo.getOrderMaterialId()+"'";
		String hql = "from Material where materialId='" + mo.getOrderMaterialId() + "'" + " and thickness = "
				+ mo.getOrderThickness() + "" + " and color = '" + mo.getOrderColor() + "'" + " and length = "
				+ mo.getOrderLength() + "";
		List materials = materialService.findByHql(hql);
		if (materials.size() > 0)
			return materials.get(0);
		else {
			hql = "from MaterialGroup where materialgroupId = '" + mo.getOrderMaterialId() + "'";
			List materialgroups = materialgroupService.findByHql(hql);
			if (materialgroups.size() > 0)
				return materialgroups.get(0);
		}
		return null;
	}

	private List<Material> getMaterialsfromGroup(MaterialGroup materialgroup) {
		List<Material> materialchildrenlist = new ArrayList();
		if (materialgroup.getMaterialchildren() != null) {
			String[] children = materialgroup.getMaterialchildren().split(",");
			List<String> materialchildrenidlist = Arrays.asList(children);
			Iterator i = materialchildrenidlist.iterator();
			while (i.hasNext()) {
				String idString = (String) i.next();
				Integer id = Integer.parseInt(idString);
				Material ml = materialService.findById(Material.class, id);
				materialchildrenlist.add(ml);
			}
		}
		return materialchildrenlist;
	}

	@RequestMapping("/editjxforder")
	public String editJxfOrder(Model model, JXFOrder order, Error errors) {
		order = jxforderService.findById(JXFOrder.class, order.getId());
		MaterialOrder mo = new MaterialOrder();
		mo.setJxforderid(order.getId());
		List<MaterialOrder> materialorderlist = materialorderService.findAllByExample(mo);
		String materialorderliststring = "";
		for(int i = 0; i<materialorderlist.size(); i++) {
			MaterialOrder tmp = materialorderlist.get(i);
			String thicknessstring = (tmp.getOrderThickness()==null)?"":tmp.getOrderThickness().toString();
			String lengthstring = (tmp.getOrderLength()==null)?"":tmp.getOrderLength().toString();
			String countstring = (tmp.getOrderCount()==null)?"":tmp.getOrderCount().toString();
			String thistmp = tmp.getLeibie()+";"+tmp.getOrderMaterialId()+";"+thicknessstring+";"+tmp.getOrderColor()+";"+lengthstring+";"+countstring;
			if (i==0){
				materialorderliststring += thistmp;
			}else{
				materialorderliststring += "," + thistmp;
			}
		}
		//model.addAttribute("materialorderliststring", materialorderliststring);
		order.setMaterialorderlist(materialorderlist);
		order.setMaterialorderliststring(materialorderliststring);
		model.addAttribute("order", order);
		String additionalmaterialstring = order.getAdditionalmaterialstring();
		if (additionalmaterialstring != null && additionalmaterialstring.length() > 0) {
			String[] additionalmaterials = additionalmaterialstring.split(",");
			List additionalmateriallist = new ArrayList();// all rows
			for (int i = 0; i < additionalmaterials.length; i++) {
				String eachrow = additionalmaterials[i];
				String[] eachparams = eachrow.split(";");
				additionalmateriallist.add(eachparams);
			}
			model.addAttribute("additionalmateriallist", additionalmateriallist);
		}
		return "erp/jxforder";
	}
	
	@RequestMapping("/printjxforder")
	public String printJxfOrder(Model model, JXFOrder order, Error errors) {
		order = jxforderService.findById(JXFOrder.class, order.getId());
		MaterialOrder mo = new MaterialOrder();
		mo.setJxforderid(order.getId());
		List<MaterialOrder> materialorderlist = materialorderService.findAllByExample(mo);
		String materialorderliststring = "";
		for(int i = 0; i<materialorderlist.size(); i++) {
			MaterialOrder tmp = materialorderlist.get(i);
			String thicknessstring = (tmp.getOrderThickness()==null)?"":tmp.getOrderThickness().toString();
			String lengthstring = (tmp.getOrderLength()==null)?"":tmp.getOrderLength().toString();
			String countstring = (tmp.getOrderCount()==null)?"":tmp.getOrderCount().toString();
			String thistmp = tmp.getLeibie()+";"+tmp.getOrderMaterialId()+";"+thicknessstring+";"+tmp.getOrderColor()+";"+lengthstring+";"+countstring;
			if (i==0){
				materialorderliststring += thistmp;
			}else{
				materialorderliststring += "," + thistmp;
			}
		}
		//model.addAttribute("materialorderliststring", materialorderliststring);
		order.setMaterialorderlist(materialorderlist);
		order.setMaterialorderliststring(materialorderliststring);
		model.addAttribute("order", order);
		String additionalmaterialstring = order.getAdditionalmaterialstring();
		if (additionalmaterialstring != null && additionalmaterialstring.length() > 0) {
			String[] additionalmaterials = additionalmaterialstring.split(",");
			List additionalmateriallist = new ArrayList();// all rows
			for (int i = 0; i < additionalmaterials.length; i++) {
				String eachrow = additionalmaterials[i];
				String[] eachparams = eachrow.split(";");
				additionalmateriallist.add(eachparams);
			}
			model.addAttribute("additionalmateriallist", additionalmateriallist);
		}
		return "erp/printjxforder";
	}

	@RequestMapping("/deletejxforder")
	public String deleteJxfOrder(Model model, JXFOrder order, Error errors) {
		order = jxforderService.findById(JXFOrder.class, order.getId());
		jxforderService.delete(order);
		return "redirect:/jxforder/alljxforder";
	}

	@RequestMapping("/savepayment")
	public String savepayment(Model model, JXFOrder order, Error errors) {
		Boolean ispaid = order.getIspaid();
		order = jxforderService.findById(JXFOrder.class, order.getId());
		order.setIspaid(ispaid);
		jxforderService.update(order);
		return "redirect:/jxforder/alljxforder";
	}

	@RequestMapping("/matchmaterialforjxforder")
	public String matchmaterialforjxforder(Model model, JXFOrder order, String matchmaterial, String outstock,
			Errors errors) {
		order = jxforderService.findById(JXFOrder.class, order.getId());
		MaterialOrder mo = new MaterialOrder();
		mo.setJxforderid(order.getId());
		List<MaterialOrder> materialorderlist = materialorderService.findAllByExample(mo);
		//leibie, identity, materialId, thickness, color, length, materialcount, pinming, materialstatus,missingcount
		String materialorderliststring = "";
		for(int i = 0; i<materialorderlist.size(); i++) {
			MaterialOrder tmp = materialorderlist.get(i);
			
			String mormgidentitystring = (tmp.getMormgidentity()==null)?"":tmp.getMormgidentity().toString();
			
			if(mormgidentitystring == ""){
				//match this and save
				Object o = getmaterial(tmp);
				if(o instanceof Material){
					Material m = (Material) o;
					tmp.setMormgidentity(m.getId());
					tmp.setOrderPinming(m.getPinming());
					tmp.setMaterialstatus("set");
					materialorderService.update(tmp);
				} else if (o instanceof MaterialGroup) {
					MaterialGroup mg = (MaterialGroup) o;
					tmp.setMormgidentity(mg.getId());
					tmp.setOrderPinming(mg.getPinming());
					tmp.setMaterialstatus("set");
					materialorderService.update(tmp);
				}
			}
			String thicknessstring = (tmp.getOrderThickness()==null)?"":tmp.getOrderThickness().toString();
			String lengthstring = (tmp.getOrderLength()==null)?"":tmp.getOrderLength().toString();
			String materialcount = (tmp.getOrderCount()==null)?"":tmp.getOrderCount().toString();
			String missingcount = (tmp.getMissingcount()==null)?"":tmp.getMissingcount().toString();
			String thistmp = tmp.getLeibie()+";"+tmp.getId()+";"+tmp.getOrderMaterialId()+";"+thicknessstring+";"+tmp.getOrderColor()+";"+lengthstring+";"+materialcount+";"+tmp.getOrderPinming()+";"+tmp.getMaterialstatus()+";"+missingcount;
			
			if (i==0){
				materialorderliststring += thistmp;
			}else{
				materialorderliststring += "," + thistmp;
			}
		}
		
		order.setMaterialorderlist(materialorderlist);
		order.setMaterialorderliststring(materialorderliststring);
		model.addAttribute("order", order);
		if (outstock != null && outstock.length() > 0) {
			errors.reject("validation.materialcount.invalid", "Check " + outstock + " is out of stock!");
			errors.reject("validation.required", new String[] { outstock }, "Material Id is requried");
		}
		String additionalmaterialstring = order.getAdditionalmaterialstring();
		if (additionalmaterialstring != null && additionalmaterialstring.length() > 0) {
			String[] additionalmaterials = additionalmaterialstring.split(",");
			List additionalmateriallist = new ArrayList();// all rows
			for (int i = 0; i < additionalmaterials.length; i++) {
				String eachrow = additionalmaterials[i];
				String[] eachparams = eachrow.split(";");
				additionalmateriallist.add(eachparams);
			}
			model.addAttribute("additionalmateriallist", additionalmateriallist);
		}
		return "erp/matchmaterialforjxforder";
	}

	@RequestMapping("/printmatchmaterialforjxforder")
	public String printmatchmaterialforjxforder(Model model, JXFOrder order, String matchmaterial, String outstock,
			Errors errors) {
		order = jxforderService.findById(JXFOrder.class, order.getId());
		MaterialOrder mo = new MaterialOrder();
		mo.setJxforderid(order.getId());
		List materialorderlist = materialorderService.findAllByExample(mo);
		order.setMaterialorderlist(materialorderlist);
		model.addAttribute("order", order);
		if (outstock != null && outstock.length() > 0) {
			errors.reject("validation.materialcount.invalid", "Check " + outstock + " is out of stock!");
			errors.reject("validation.required", new String[] { outstock }, "Material Id is requried");
		}
		String additionalmaterialstring = order.getAdditionalmaterialstring();
		if (additionalmaterialstring != null && additionalmaterialstring.length() > 0) {
			String[] additionalmaterials = additionalmaterialstring.split(",");
			List additionalmateriallist = new ArrayList();
			for (int i = 0; i < additionalmaterials.length; i++) {
				String eachrow = additionalmaterials[i];
				String[] eachparams = eachrow.split(";");
				additionalmateriallist.add(eachparams);
			}
			model.addAttribute("additionalmateriallist", additionalmateriallist);
		}
		return "erp/printmatchmaterialforjxforder";
	}

	@RequestMapping("/savematchmaterial")
	public String savematchmaterial(Model model, JXFOrder order, String matchmaterial, Error errors) {
		return "redirect:/jxforder/alljxforder";
	}

	@RequestMapping("/jxfordertotransactionout")
	public String jxfordertotransactionout(Model model, JXFOrder order, Errors errors) {
		String additionalmaterialstring = order.getAdditionalmaterialstring();
		String calweightstring = order.getCalweight();
		Double actweight = order.getActweight();
		String unitprice = order.getUnitprice();
		Double actincome = order.getActincome();
		Double additionalincome = order.getAdditionalincome();
		Double totalincome = order.getTotalincome();
		Boolean ispaid = order.getIspaid();
		String memo = order.getMemo();
		String expressinfo = order.getExpressinfo();
		order = jxforderService.findById(JXFOrder.class, order.getId());
		// 发货前先检查是否全部匹配，全部都够，此时不再需要检查
		// order.setJxforderstatus("allset");
		jxforderService.update(order);
		MaterialOrder motmp = new MaterialOrder();
		motmp.setJxforderid(order.getId());
		order.setMaterialorderlist(materialorderService.findAllByExample(motmp));
		// 所有物料全部匹配，并且库存都足，拼接transaction太麻烦，还是用transaction
		// out来判断，复用transactioncontroller里面的逻辑
		// 全部发货
		/*
		 * Transaction transaction = getTransactionfromJxfOrder(order); String
		 * result = ""; result = savecreateTransactionsout(model, transaction,
		 * errors); if (result != "" && result != "transactionSuccess") return
		 * "redirect:/jxforder/matchmaterialforjxforder?id=" + order.getId() +
		 * "&outstock=" + result;
		 * 
		 * // 把所有materialordder设置成完成发货 List<MaterialOrder> materialorderlist =
		 * order.getMaterialorderlist(); Iterator<MaterialOrder> i =
		 * materialorderlist.iterator(); while (i.hasNext()) { MaterialOrder mo
		 * = i.next(); mo.setMaterialstatus("completed");
		 * materialorderService.update(mo); }
		 */

		order.setAdditionalmaterialstring(additionalmaterialstring);
		order.setCalweight(calweightstring);
		order.setActweight(actweight);
		order.setUnitprice(unitprice);
		order.setActincome(actincome);
		order.setAdditionalincome(additionalincome);
		order.setTotalincome(totalincome);
		order.setIspaid(ispaid);
		order.setMemo(memo);
		order.setExpressinfo(expressinfo);
		// order.setJxforderstatus("completed");
		jxforderService.update(order);

		return "redirect:/jxforder/alljxforder";
	}

	// 剩余未发货非completed状态部分的materialorder组成的transaction
	private Transaction getTransactionfromJxfOrder(JXFOrder order) {
		Transaction transaction = new Transaction();
		transaction.setType("OUT");
		transaction.setOrderNo(order.getOrderId());
		transaction.setCustomer(order.getCustomer());
		String materialchildren = "";
		String materialcount = "";
		String materialtype = "";
		List<MaterialOrder> materiallist = new ArrayList<MaterialOrder>(order.getMaterialorderlist());
		for (int j = 0; j < materiallist.size(); j++) {

			MaterialOrder mo = materiallist.get(j);
			if (!mo.getMaterialstatus().equals("completed")) {
				if (j == 0) {
					materialchildren = materialchildren + mo.getMormgidentity();
					materialcount = materialcount + mo.getOrderCount();
					materialtype = materialtype + mo.getType();
				} else {
					materialchildren = materialchildren + "," + mo.getMormgidentity();
					materialcount = materialcount + "," + mo.getOrderCount();
					materialtype = materialtype + "," + mo.getType();
				}
			}
		}
		transaction.setMaterialchildren(materialchildren);
		transaction.setMaterialcount(materialcount);
		transaction.setMaterialtype(materialtype);
		return transaction;
	}

	public String savecreateTransactionsout(Model model, @Valid @ModelAttribute("transaction") Transaction transaction,
			Errors errors) {
		String materialchildrenstring = transaction.getMaterialchildren();
		String materialchildrencountstring = transaction.getMaterialcount();
		String materialtypestring = transaction.getMaterialtype();
		String[] materialidlist = materialchildrenstring.split(",");
		String[] materialcountlist = materialchildrencountstring.split(",");
		String[] materialtypelist = materialtypestring.split(",");

		ArrayList<Integer> allmaterialids = new ArrayList<Integer>();
		ArrayList<Integer> materialtranscounts = new ArrayList<Integer>();

		if (materialchildrenstring != "" && materialchildrencountstring != "" && materialtypestring != ""
				&& materialidlist.length != 0 && materialcountlist.length != 0 && materialtypelist.length != 0
				&& materialidlist.length == materialcountlist.length
				&& materialidlist.length == materialtypelist.length) {

			for (int i = 0; i < materialidlist.length; i++) {
				String materialtype = materialtypelist[i];
				if (materialtype.equals("material")) {
					Integer id = Integer.parseInt(materialidlist[i]);
					Integer tmaterialcount = Integer.parseInt(materialcountlist[i]);
					allmaterialids.add(id);
					materialtranscounts.add(tmaterialcount);
					// saveSimpleMaterial(transaction, id, tmaterialcount);
				} else {
					Integer materiagrouplId = Integer.parseInt(materialidlist[i]);// for
																					// each
																					// material
																					// gorup,
																					// find
																					// materials
					MaterialGroup mg = materialgroupService.findById(MaterialGroup.class, materiagrouplId);
					String materials = mg.getMaterialchildren();//
					if (materials != null) {
						String[] children = materials.split(",");// for each
																	// material
																	// in
																	// materialgroup
						for (int j = 0; j < children.length; j++) {
							Integer id = Integer.parseInt(children[j]);
							Integer tmaterialcount = Integer.parseInt(materialcountlist[i]);
							allmaterialids.add(id);
							materialtranscounts.add(tmaterialcount);
							// saveSimpleMaterial(transaction, id,
							// tmaterialcount);
						}
					}
				}
			}

			// organize material results
			ArrayList<Integer> resultmaterialids = new ArrayList<Integer>();
			ArrayList<Integer> resultmaterialtranscounts = new ArrayList<Integer>();
			for (int i = 0; i < allmaterialids.size(); i++) {
				Integer id = allmaterialids.get(i);// this id;
				Integer tcount = materialtranscounts.get(i);
				if (i == 0) {
					resultmaterialids.add(id);
					resultmaterialtranscounts.add(tcount);
				} else {

					for (int j = 0; j <= i; j++) {
						if (j < i) {
							if (id != allmaterialids.get(j))// this id equals
								continue; // previous id
							else {
								int found = 0;
								for (int c = 0; c < resultmaterialids.size(); c++) {
									if (id == resultmaterialids.get(c)) {
										resultmaterialtranscounts.set(c, resultmaterialtranscounts.get(c) + tcount);
										found = 1;
										break;
									}
								}
								if (found == 1)
									break;
							}
						} else {
							resultmaterialids.add(id);
							resultmaterialtranscounts.add(tcount);
						}

					}

				}
			}

			// check materials stock, if all available, then transaction can be
			// done
			for (int i = 0; i < resultmaterialids.size(); i++) {
				Integer id = resultmaterialids.get(i);
				Integer transcount = resultmaterialtranscounts.get(i);
				Material ml = materialService.findById(Material.class, id);
				if (ml.getCount() < transcount) {
					errors.reject("validation.materialcount.invalid",
							"Check " + ml.getMaterialId() + " is out of stock!");
					return ml.getPinming();
				}
			}
			// do the transactions
			for (int c = 0; c < allmaterialids.size(); c++) {
				saveSimpleMaterial(transaction, allmaterialids.get(c), materialtranscounts.get(c), "OUT");
			}
		}

		return "transactionSuccess";
	}

	private void saveSimpleMaterial(Transaction transaction, Integer id, Integer tmaterialcount, String type) {
		Material ml = materialService.findById(Material.class, id);
		if (tmaterialcount == null)
			tmaterialcount = 0;
		// if (mlaccount > ml.getCount()) {
		// errors.reject("validation.materialcount.invalid", "Material is out of
		// stock!");
		// return "erp/savecreatetransactionsout";
		// }
		if (type.equals("OUT")) {
			ml.setCount(ml.getCount() - tmaterialcount);
		} else if (type.equals("IN")) {
			ml.setCount(ml.getCount() + tmaterialcount);
		}
		if (ml.getCount() < ml.getRiskcount()) {
			ml.setRiskflag(1);
		} else {
			ml.setRiskflag(0);
		}
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		ml.setUpdatedBy(user);
		ml.setUpdatedOn(new Date());
		materialService.update(ml);
		Transaction ts = new Transaction();
		ts.setType(type);
		ts.setOrderNo(transaction.getOrderNo());
		ts.setCustomer(transaction.getCustomer());
		ts.setMaterial(ml);
		ts.setCount(tmaterialcount);
		ts.setCreatedBy(user);
		ts.setCreatedOn(new Date());
		ts.setUpdatedBy(user);
		ts.setUpdatedOn(new Date());
		transactionService.save(ts);
	}

	@RequestMapping(value = "checkallenoughstock", produces = "text/html;charset=UTF-8;")
	@ResponseBody
	public String checkallenoughstock(Integer identity) {
		JXFOrder order = jxforderService.findById(JXFOrder.class, identity);
		MaterialOrder motmp = new MaterialOrder();
		motmp.setJxforderid(order.getId());
		order.setMaterialorderlist(materialorderService.findAllByExample(motmp));
		Transaction transaction = getTransactionfromJxfOrder(order);
		String materialchildrenstring = transaction.getMaterialchildren();
		String materialchildrencountstring = transaction.getMaterialcount();
		String materialtypestring = transaction.getMaterialtype();
		String[] materialidlist = materialchildrenstring.split(",");
		String[] materialcountlist = materialchildrencountstring.split(",");
		String[] materialtypelist = materialtypestring.split(",");

		ArrayList<Integer> allmaterialids = new ArrayList<Integer>();
		ArrayList<Integer> materialtranscounts = new ArrayList<Integer>();

		if (materialidlist.length != 0 && materialcountlist.length != 0 && materialtypelist.length != 0
				&& materialidlist.length == materialcountlist.length
				&& materialidlist.length == materialtypelist.length) {

			for (int i = 0; i < materialidlist.length; i++) {
				String materialtype = materialtypelist[i];
				if (materialtype.equals("material")) {
					Integer id = Integer.parseInt(materialidlist[i]);
					Integer tmaterialcount = Integer.parseInt(materialcountlist[i]);
					allmaterialids.add(id);
					materialtranscounts.add(tmaterialcount);
					// saveSimpleMaterial(transaction, id, tmaterialcount);
				} else {
					// for each material group, find materials
					Integer materiagrouplId = Integer.parseInt(materialidlist[i]);
					MaterialGroup mg = materialgroupService.findById(MaterialGroup.class, materiagrouplId);
					String materials = mg.getMaterialchildren();//
					if (materials != null) {
						// for each material in materialgroup
						String[] children = materials.split(",");
						for (int j = 0; j < children.length; j++) {
							Integer id = Integer.parseInt(children[j]);
							Integer tmaterialcount = Integer.parseInt(materialcountlist[i]);
							allmaterialids.add(id);
							materialtranscounts.add(tmaterialcount);
						}
					}
				}
			}
			// organize material results
			ArrayList<Integer> resultmaterialids = new ArrayList<Integer>();
			ArrayList<Integer> resultmaterialtranscounts = new ArrayList<Integer>();
			for (int i = 0; i < allmaterialids.size(); i++) {
				Integer id = allmaterialids.get(i);// this id;
				Integer tcount = materialtranscounts.get(i);
				if (i == 0) {
					resultmaterialids.add(id);
					resultmaterialtranscounts.add(tcount);
				} else {
					for (int j = 0; j <= i; j++) {
						if (j < i) {
							if (id != allmaterialids.get(j))// this id equals
								continue; // previous id
							else {
								int found = 0;
								for (int c = 0; c < resultmaterialids.size(); c++) {
									if (id == resultmaterialids.get(c)) {
										resultmaterialtranscounts.set(c, resultmaterialtranscounts.get(c) + tcount);
										found = 1;
										break;
									}
								}
								if (found == 1)
									break;
							}
						} else {
							resultmaterialids.add(id);
							resultmaterialtranscounts.add(tcount);
						}
					}
				}
			}
			// check materials stock, if all available, then transaction can be
			// done
			for (int i = 0; i < resultmaterialids.size(); i++) {
				Integer id = resultmaterialids.get(i);
				Integer transcount = resultmaterialtranscounts.get(i);
				Material ml = materialService.findById(Material.class, id);
				if (ml.getCount() < transcount) {
					return ml.getPinming();
				}
			}
			return "true";
		} else
			return "false";
	}

	@RequestMapping(value = "checkmaterialorderstock", produces = "text/html;charset=UTF-8;")
	@ResponseBody
	public String checkmaterialorderstock(String identitylist, String outcountlist) {
		String materialchildrenstring = "";
		String materialchildrencountstring = "";
		String materialtypestring = "";
		String[] identities = identitylist.split(",");
		String[] outcounts = outcountlist.split(",");
		for (int i = 0; i < identities.length; i++) {
			Integer id = Integer.parseInt(identities[i]);
			Integer outcount = Integer.parseInt(outcounts[i]);
			MaterialOrder mo = materialorderService.findById(MaterialOrder.class, id);
			if (i == 0) {
				materialchildrenstring = mo.getMormgidentity().toString();
				materialchildrencountstring = outcount.toString();
				materialtypestring = mo.getType();
			} else {
				materialchildrenstring = materialchildrenstring + "," + mo.getMormgidentity().toString();
				materialchildrencountstring = materialchildrencountstring + "," + outcount.toString();
				materialtypestring = materialtypestring + "," + mo.getType();
			}
		}

		String[] materialidlist = materialchildrenstring.split(",");
		String[] materialcountlist = materialchildrencountstring.split(",");
		String[] materialtypelist = materialtypestring.split(",");

		ArrayList<Integer> allmaterialids = new ArrayList<Integer>();
		ArrayList<Integer> materialtranscounts = new ArrayList<Integer>();

		if (materialidlist.length != 0 && materialcountlist.length != 0 && materialtypelist.length != 0
				&& materialidlist.length == materialcountlist.length
				&& materialidlist.length == materialtypelist.length) {

			for (int i = 0; i < materialidlist.length; i++) {
				String materialtype = materialtypelist[i];
				if (materialtype.equals("material")) {
					Integer id = Integer.parseInt(materialidlist[i]);
					Integer tmaterialcount = Integer.parseInt(materialcountlist[i]);
					allmaterialids.add(id);
					materialtranscounts.add(tmaterialcount);
					// saveSimpleMaterial(transaction, id, tmaterialcount);
				} else {
					// for each material group, find materials
					Integer materiagrouplId = Integer.parseInt(materialidlist[i]);
					MaterialGroup mg = materialgroupService.findById(MaterialGroup.class, materiagrouplId);
					String materials = mg.getMaterialchildren();//
					if (materials != null) {
						// for each material in materialgroup
						String[] children = materials.split(",");
						for (int j = 0; j < children.length; j++) {
							Integer id = Integer.parseInt(children[j]);
							Integer tmaterialcount = Integer.parseInt(materialcountlist[i]);
							allmaterialids.add(id);
							materialtranscounts.add(tmaterialcount);
						}
					}
				}
			}
			// organize material results
			ArrayList<Integer> resultmaterialids = new ArrayList<Integer>();
			ArrayList<Integer> resultmaterialtranscounts = new ArrayList<Integer>();
			for (int i = 0; i < allmaterialids.size(); i++) {
				Integer id = allmaterialids.get(i);// this id;
				Integer tcount = materialtranscounts.get(i);
				if (i == 0) {
					resultmaterialids.add(id);
					resultmaterialtranscounts.add(tcount);
				} else {
					for (int j = 0; j <= i; j++) {
						if (j < i) {
							if (id != allmaterialids.get(j))// this id equals
								continue; // previous id
							else {
								int found = 0;
								for (int c = 0; c < resultmaterialids.size(); c++) {
									if (id == resultmaterialids.get(c)) {
										resultmaterialtranscounts.set(c, resultmaterialtranscounts.get(c) + tcount);
										found = 1;
										break;
									}
								}
								if (found == 1)
									break;
							}
						} else {
							resultmaterialids.add(id);
							resultmaterialtranscounts.add(tcount);
						}
					}
				}
			}
			// check materials stock, if all available, then transaction can be
			// done
			for (int i = 0; i < resultmaterialids.size(); i++) {
				Integer id = resultmaterialids.get(i);
				Integer transcount = resultmaterialtranscounts.get(i);
				Material ml = materialService.findById(Material.class, id);
				if (ml.getCount() < transcount) {
					return ml.getPinming();
				}
			}
			return "true";
		} else
			return "false";
	}

	@RequestMapping(value = "outmaterialorderstock", produces = "text/html;charset=UTF-8;")
	@ResponseBody
	public String outmaterialorderstock(String identitylist, String outcountlist) {
		String orderno = "";
		Customer customer = new Customer();
		String materialchildrenstring = "";
		String materialchildrencountstring = "";
		String materialtypestring = "";
		String[] identities = identitylist.split(",");
		String[] outcounts = outcountlist.split(",");
		JXFOrder order = new JXFOrder();
		for (int i = 0; i < identities.length; i++) {
			Integer id = Integer.parseInt(identities[i]);
			Integer outcount = Integer.parseInt(outcounts[i]);
			MaterialOrder mo = materialorderService.findById(MaterialOrder.class, id);
			// set mo status and missingcount
			mo.setMissingcount(mo.getMissingcount() - outcount);
			if (mo.getMissingcount() == 0) {
				mo.setMaterialstatus("completed");
			} else {
				mo.setMaterialstatus("partial");
			}
			materialorderService.update(mo);
			if (i == 0) {
				materialchildrenstring = mo.getMormgidentity().toString();
				materialchildrencountstring = outcount.toString();
				materialtypestring = mo.getType();
				Integer orderidentity = mo.getJxforderid();
				order = jxforderService.findById(JXFOrder.class, orderidentity);
				orderno = order.getOrderId();
				customer = order.getCustomer();
			} else {
				materialchildrenstring = materialchildrenstring + "," + mo.getMormgidentity().toString();
				materialchildrencountstring = materialchildrencountstring + "," + outcount.toString();
				materialtypestring = materialtypestring + "," + mo.getType();
			}
			// materialorderlist.add(mo);
		}

		String[] materialidlist = materialchildrenstring.split(",");
		String[] materialcountlist = materialchildrencountstring.split(",");
		String[] materialtypelist = materialtypestring.split(",");

		ArrayList<Integer> allmaterialids = new ArrayList<Integer>();
		ArrayList<Integer> materialtranscounts = new ArrayList<Integer>();

		if (materialidlist.length != 0 && materialcountlist.length != 0 && materialtypelist.length != 0
				&& materialidlist.length == materialcountlist.length
				&& materialidlist.length == materialtypelist.length) {

			for (int i = 0; i < materialidlist.length; i++) {
				String materialtype = materialtypelist[i];
				if (materialtype.equals("material")) {
					Integer id = Integer.parseInt(materialidlist[i]);
					Integer tmaterialcount = Integer.parseInt(materialcountlist[i]);
					allmaterialids.add(id);
					materialtranscounts.add(tmaterialcount);
					// saveSimpleMaterial(transaction, id, tmaterialcount);
				} else {
					// for each material group, find materials
					Integer materiagrouplId = Integer.parseInt(materialidlist[i]);
					MaterialGroup mg = materialgroupService.findById(MaterialGroup.class, materiagrouplId);
					String materials = mg.getMaterialchildren();//
					if (materials != null) {
						// for each material in materialgroup
						String[] children = materials.split(",");
						for (int j = 0; j < children.length; j++) {
							Integer id = Integer.parseInt(children[j]);
							Integer tmaterialcount = Integer.parseInt(materialcountlist[i]);
							allmaterialids.add(id);
							materialtranscounts.add(tmaterialcount);
						}
					}
				}
			}
			// organize material results
			ArrayList<Integer> resultmaterialids = new ArrayList<Integer>();
			ArrayList<Integer> resultmaterialtranscounts = new ArrayList<Integer>();
			for (int i = 0; i < allmaterialids.size(); i++) {
				Integer id = allmaterialids.get(i);// this id;
				Integer tcount = materialtranscounts.get(i);
				if (i == 0) {
					resultmaterialids.add(id);
					resultmaterialtranscounts.add(tcount);
				} else {
					for (int j = 0; j <= i; j++) {
						if (j < i) {
							if (id != allmaterialids.get(j))// this id equals
								continue; // previous id
							else {
								int found = 0;
								for (int c = 0; c < resultmaterialids.size(); c++) {
									if (id == resultmaterialids.get(c)) {
										resultmaterialtranscounts.set(c, resultmaterialtranscounts.get(c) + tcount);
										found = 1;
										break;
									}
								}
								if (found == 1)
									break;
							}
						} else {
							resultmaterialids.add(id);
							resultmaterialtranscounts.add(tcount);
						}
					}
				}
			}
			// 所有匹配物料出库
			for (int c = 0; c < allmaterialids.size(); c++) {
				Transaction transaction = new Transaction();
				transaction.setOrderNo(orderno);
				transaction.setCustomer(customer);
				saveSimpleMaterial(transaction, allmaterialids.get(c), materialtranscounts.get(c), "OUT");
			}
			// 把原有的那些materialorder设成complete，这一步要在前面做，因为partial出库的情况，需要判断，如果出库数量跟订单数量一致，则设置materialorder
			// status为completed，否则应该把那个materialorder设置成partial
			/*
			 * Iterator<MaterialOrder> i = materialorderlist.iterator(); while
			 * (i.hasNext()) { MaterialOrder mo = i.next();
			 * mo.setMaterialstatus("completed");
			 * materialorderService.update(mo); }
			 */
			// 把原订单设置成部分出货
			order.setJxforderstatus("partial");
			jxforderService.update(order);

			// check all materialout, if all out, set the order status as
			// completed
			MaterialOrder motmp = new MaterialOrder();
			motmp.setJxforderid(order.getId());
			List<MaterialOrder> allmolistoforder = materialorderService.findAllByExample(motmp);
			for (int j = 0; j < allmolistoforder.size(); j++) {
				MaterialOrder mo = allmolistoforder.get(j);
				if (j == allmolistoforder.size() - 1) {
					if (mo.getMaterialstatus().equals("completed")) {
						order.setJxforderstatus("completed");
						jxforderService.update(order);
					} else {
						order.setJxforderstatus("partial");
						jxforderService.update(order);
					}
				} else if (mo.getMaterialstatus().equals("completed")) {
					continue;
				} else {
					order.setJxforderstatus("partial");
					jxforderService.update(order);
					break;
				}
			}
			return "true";
		} else
			return "false";
	}

	@RequestMapping(value = "getallmaterialorder", produces = "text/html;charset=UTF-8;")
	@ResponseBody
	public String getallmaterialorder() {
		String materialorders = "";
		List<MaterialOrder> molist = new ArrayList();
		List<Material> mlist = materialService.findAll(Material.class);
		List<MaterialGroup> mglist = materialgroupService.findAll(MaterialGroup.class);
		for (int i = 0; i < mlist.size(); i++) {
			MaterialOrder mo = getMaterialOrderfromObject(mlist.get(i));
			if (mo != null)
				molist.add(mo);
		}
		for (int i = 0; i < mglist.size(); i++) {
			MaterialOrder mo = getMaterialOrderfromObject(mglist.get(i));
			if (mo != null)
				molist.add(mo);
		}
		for (int i = 0; i < molist.size(); i++) {
			MaterialOrder mo = molist.get(i);
			if (i == 0) {
				materialorders = getMateriOrderStringfororderinput(mo);
			} else {
				materialorders = materialorders + "," + getMateriOrderStringfororderinput(mo);
			}
		}
		return materialorders;
	}

	MaterialOrder getMaterialOrderfromObject(Object o) {
		MaterialOrder mo = new MaterialOrder();
		if (o instanceof Material) {
			Material m = (Material) o;
			mo.setType("material");
			mo.setOrderMaterialId(m.getMaterialId());
			mo.setOrderThickness(m.getThickness());
			mo.setOrderColor(m.getColor());
			mo.setOrderLength(m.getLength());
			return mo;
		} else if (o instanceof MaterialGroup) {
			MaterialGroup mg = (MaterialGroup) o;
			mo.setType("materialgroup");
			mo.setOrderMaterialId(mg.getMaterialgroupId());
			mo.setOrderThickness(null);
			mo.setOrderColor(null);
			mo.setOrderLength(null);
			return mo;
		}
		return null;
	}

	public String getMateriOrderStringfororderinput(MaterialOrder mo) {
		String result = "";
		result = mo.getOrderMaterialId();
		if (mo.getOrderThickness() != null) {
			result = result + ";" + mo.getOrderThickness() + ";" + mo.getOrderColor() + ";" + mo.getOrderLength();
		} else {
			result = result + ";;;";
		}
		return result;
	}
}
