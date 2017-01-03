package com.jxf.oa.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

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
import com.jxf.oa.entity.JXFOrder;
import com.jxf.oa.entity.Material;
import com.jxf.oa.entity.MaterialGroup;
import com.jxf.oa.entity.MaterialOrder;
import com.jxf.oa.entity.Salesman;
import com.jxf.oa.entity.Transaction;
import com.jxf.oa.entity.User;
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

		Double listcalweight = 0.0;
		Double listactweight = 0.0;
		Double listtotalincome = 0.0;
		for (int i = 0; i < jxforderlist.size(); i++) {
			JXFOrder o = jxforderlist.get(i);
			if (o.getCalweight() != null)
				listcalweight = listcalweight + o.getCalweight();
			if (o.getActweight() != null)
				listactweight = listactweight + o.getActweight();
			if (o.getTotalincome() != null)
				listtotalincome = listtotalincome + o.getTotalincome();
		}
		model.addAttribute("listcalweight", listcalweight);
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

	// use this for save and edit
	@RequestMapping("/savecreateorder")
	public String savecreateOrder(Model model, @Valid @ModelAttribute JXFOrder order, String materialchildrenstring,
			Errors errors) {
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
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
			jxforderService.save(order);
		}

		workingorder = jxforderService.findById(JXFOrder.class, order.getId());

		// clear original children list
		Set originalmaterialorderlist = workingorder.getMaterialorderlist();
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
						String materialid = materialparams[1];// ordermaterialId
						if (materialid != null && materialid != "") {
							mo.setOrderMaterialId(materialid.toUpperCase());
							String idstring = materialparams[0];// identity, if
																// identity
																// exists,
																// update; else
																// save this
																// material
							String thicknessstring = null;
							if (materialparams.length > 2) {
								thicknessstring = materialparams[2];// orderThickness
							}
							String colorstring = null;
							if (materialparams.length > 3) {
								colorstring = materialparams[3];// orderColor
							}
							String lengthstring = null;
							if (materialparams.length > 4) {
								lengthstring = materialparams[4];// orderLength
							}
							String countstring = null;
							if (materialparams.length > 5) {
								countstring = materialparams[5];// orderCount
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
							mo.setOrderThickness(thickness);
							mo.setOrderColor(colorstring);
							mo.setOrderLength(length);
							mo.setOrderCount(count);
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
			Double calWeight = 0.0;
			// set calculated weight
			for (int i = 0; i < list.size(); i++) {
				// find the calculated weight;
				MaterialOrder mo = list.get(i);
				Double mWeight = 0.0;
				if (mo.getMaterialWeight() != null && mo.getOrderCount() != null) {
					mWeight = mo.getMaterialWeight() * mo.getOrderCount();
				}
				calWeight = calWeight + mWeight;
			}
			workingorder.setCalweight(calWeight);
		}
		// check whether allset

		// 所有物料全部匹配，才发货
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
		order.getMaterialorderlist();
		model.addAttribute("order", order);
		String additionalmaterialstring = order.getAdditionalmaterialstring();
		if (additionalmaterialstring != null && additionalmaterialstring.length() > 0) {
			String[] additionalmaterials = additionalmaterialstring.split(",");
			List additionalmateriallist = new ArrayList();//all rows
			for (int i = 0; i < additionalmaterials.length; i++) {
				String eachrow = additionalmaterials[i];
				String[] eachparams = eachrow.split(";");
				additionalmateriallist.add(eachparams);
			}
			model.addAttribute("additionalmateriallist", additionalmateriallist);
		}
		return "erp/jxforder";
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
		model.addAttribute("order", order);
		if (outstock != null && outstock.length() > 0) {
			errors.reject("validation.materialcount.invalid", "Check " + outstock + " is out of stock!");
			errors.reject("validation.required", new String[] { outstock }, "Material Id is requried");
		}
		String additionalmaterialstring = order.getAdditionalmaterialstring();
		if (additionalmaterialstring != null && additionalmaterialstring.length() > 0) {
			String[] additionalmaterials = additionalmaterialstring.split(",");
			List additionalmateriallist = new ArrayList();//all rows
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
		Double actweight = order.getActweight();
		Double unitprice = order.getUnitprice();
		Double actincome = order.getActincome();
		Double additionalincome = order.getAdditionalincome();
		Double totalincome = order.getTotalincome();
		Boolean ispaid = order.getIspaid();
		order = jxforderService.findById(JXFOrder.class, order.getId());
		Set<MaterialOrder> materialorderlist = order.getMaterialorderlist();
		Iterator<MaterialOrder> i = materialorderlist.iterator();
		// 所有物料全部匹配，才发货
		while (i.hasNext()) {
			MaterialOrder mo = i.next();
			if (mo.getMaterialstatus() != null && mo.getMaterialstatus().equals("draft")) {
				errors.reject("validation.material.invalid", "未找到匹配物料!");
				return "redirect:/jxforder/matchmaterialforjxforder?id=" + order.getId();
			}
		}
		order.setJxforderstatus("allset");
		jxforderService.update(order);
		// 所有物料全部匹配，并且库存都足，拼接transaction太麻烦，还是用transaction
		// out来判断，复用transactioncontroller里面的逻辑
		// 发货
		Transaction transaction = getTransactionfromJxfOrder(order);

		String result = "";
		result = savecreateTransactionsout(model, transaction, errors);
		if (result != "" && result != "transactionSuccess")
			return "redirect:/jxforder/matchmaterialforjxforder?id=" + order.getId() + "&outstock=" + result;
		order.setAdditionalmaterialstring(additionalmaterialstring);
		order.setActweight(actweight);
		order.setUnitprice(unitprice);
		order.setActincome(actincome);
		order.setAdditionalincome(additionalincome);
		order.setTotalincome(totalincome);
		order.setIspaid(ispaid);
		order.setJxforderstatus("completed");
		jxforderService.update(order);

		return "redirect:/jxforder/alljxforder";
	}

	private Transaction getTransactionfromJxfOrder(JXFOrder order) {
		// TODO Auto-generated method stub
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

	@RequestMapping(value="checkallenoughstock" , produces="text/html;charset=UTF-8;")
	@ResponseBody
	public String checkallenoughstock(Integer identity) {
		JXFOrder order = jxforderService.findById(JXFOrder.class, identity);
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
					return ml.getPinming();
				}
			}
			return "true";
		} else
			return "false";
	}
	
	@RequestMapping(value="getallmaterialorder" , produces="text/html;charset=UTF-8;")
	@ResponseBody
	public String getallmaterialorder() {
		String materialorders = "";
		List<MaterialOrder> molist = new ArrayList();
		List<Material> mlist = materialService.findAll(Material.class);
		List<MaterialGroup> mglist = materialgroupService.findAll(MaterialGroup.class);
		for (int i =0; i<mlist.size(); i++){
			MaterialOrder mo = getMaterialOrderfromObject(mlist.get(i));
			if(mo!=null)
				molist.add(mo);
		}
		for (int i =0; i<mglist.size(); i++){
			MaterialOrder mo = getMaterialOrderfromObject(mglist.get(i));
			if(mo!=null)
				molist.add(mo);
		}
		for(int i = 0; i<molist.size(); i++){
			MaterialOrder mo = molist.get(i);
			if(i==0){
				materialorders = getMateriOrderStringfororderinput(mo);
			}else{
				materialorders = materialorders + "," + getMateriOrderStringfororderinput(mo);
			}
		}
		return materialorders;
	}
	
	MaterialOrder getMaterialOrderfromObject(Object o){
		MaterialOrder mo = new MaterialOrder();
		if(o instanceof Material){
			Material m = (Material) o;
			mo.setType("material");
			mo.setOrderMaterialId(m.getMaterialId());
			mo.setOrderThickness(m.getThickness());
			mo.setOrderColor(m.getColor());
			mo.setOrderLength(m.getLength());
			return mo;
		}else if(o instanceof MaterialGroup){
			MaterialGroup mg = (MaterialGroup) o;
			mo.setType("material");
			mo.setOrderMaterialId(mg.getMaterialgroupId());
			mo.setOrderThickness(null);
			mo.setOrderColor(null);
			mo.setOrderLength(null);
			return mo;
		}
		return null;
	}
	
	public String getMateriOrderStringfororderinput(MaterialOrder mo){
		String result = "";
		result = mo.getOrderMaterialId();
		if(mo.getOrderThickness()!=null) {
			result = result + ";"+mo.getOrderThickness() + ";" + mo.getOrderColor() + ";" + mo.getOrderLength();
		}
		else {
			result = result +";;;";
		}
		return result;
	}
}
