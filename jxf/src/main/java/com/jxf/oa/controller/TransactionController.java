package com.jxf.oa.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
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

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.Customer;
import com.jxf.oa.entity.Material;
import com.jxf.oa.entity.MaterialElement;
import com.jxf.oa.entity.MaterialGroup;
import com.jxf.oa.entity.MaterialOrder;
import com.jxf.oa.entity.Transaction;
import com.jxf.oa.entity.User;
import com.jxf.oa.services.CustomerService;
import com.jxf.oa.services.MaterialService;
import com.jxf.oa.services.TransactionService;

@Controller
@RequestMapping("/transaction")
public class TransactionController extends BaseController {
	@Autowired
	TransactionService transactionService;
	@Autowired
	MaterialService materialService;
	@Autowired
	MaterialService materialgroupService;
	@Autowired
	CustomerService customerService;

	@RequestMapping("/alltransactionlist")
	public String allTransactionList(Model model, @RequestParam(required = false, defaultValue = "1") Integer page) {
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		Page<Transaction> transactionlists = transactionService.findAllTransaction(page, getPageSize(), user.getId());
		model.addAttribute("page", transactionlists);
		model.addAttribute("transaction", new Transaction());
		return "erp/alltransactionlist";
	}

	@RequestMapping("/in")
	public String addinTransaction(Model model, @Valid @ModelAttribute Transaction transaction, Errors errors) {
		transaction.setType("IN");
		model.addAttribute("transaction", transaction);
		return "erp/createtransaction";
	}

	@RequestMapping("/batchin")
	public String batchinTransaction(Model model, @Valid @ModelAttribute Transaction transaction, Errors errors) {
		String TIME_FORMAT = "yyyyMMddHHmmssSSS";
		SimpleDateFormat sf = new SimpleDateFormat(TIME_FORMAT);
		String orderNo = sf.format(new Date());
		transaction.setOrderNo(orderNo);
		transaction.setType("IN");
		model.addAttribute("transaction", transaction);
		return "erp/createtransactionsin";
	}

	@RequestMapping("/out")
	public String addoutTransaction(Model model, @Valid @ModelAttribute Transaction transaction, Errors errors) {
		transaction.setType("OUT");
		model.addAttribute("transaction", transaction);
		return "erp/createtransaction";
	}

	@RequestMapping("/batchout")
	public String batchoutTransaction(Model model, @Valid @ModelAttribute Transaction transaction, Errors errors) {
		String TIME_FORMAT = "yyyyMMddHHmmssSSS";
		SimpleDateFormat sf = new SimpleDateFormat(TIME_FORMAT);
		String orderNo = sf.format(new Date());
		transaction.setOrderNo(orderNo);
		transaction.setType("OUT");
		model.addAttribute("transaction", transaction);
		return "erp/createtransactionsout";
	}

	@RequestMapping("/return")
	public String addreturnTransaction(Model model, @Valid @ModelAttribute Transaction transaction, Errors errors) {
		transaction.setType("RETURN");
		return "erp/createtransaction";
	}

	@RequestMapping("/savecreatetransaction")
	public String savecreateTransaction(Model model, @Valid @ModelAttribute("transaction") Transaction transaction,
			Errors errors) {
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;

		// update material count
		Material ml = transaction.getMaterial();
		ml = materialService.findById(Material.class, ml.getId());
		Integer mlaccount = ml.getCount();
		if (mlaccount == null)
			mlaccount = 0;
		if (transaction.getType().equals("IN")) {
			ml.setCount(mlaccount + transaction.getCount());
		} else {
			// update material count
			if (mlaccount < transaction.getCount()) {
				errors.reject("validation.materialcount.invalid", "Material is out of stock!");
				return "erp/createtransaction";
			}
			ml.setCount(mlaccount - transaction.getCount());
		}

		if (ml.getCount() < ml.getRiskcount()) {
			ml.setRiskflag(1);
		} else {
			ml.setRiskflag(0);
		}
		ml.setUpdatedBy(user);
		ml.setUpdatedOn(new Date());
		materialService.update(ml);

		transaction.setCreatedBy(user);
		transaction.setCreatedOn(new Date());
		transaction.setUpdatedBy(user);
		transaction.setUpdatedOn(new Date());
		transactionService.save(transaction);

		return "transactionSuccess";
	}

	@RequestMapping("/searchtransaction")
	public String searchTransaction(Model model, @Valid @ModelAttribute("transaction") Transaction transaction,
			@RequestParam(required = false, defaultValue = "1") Integer page, Errors errors) {
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		if (transaction.getMaterial() != null && transaction.getMaterial().getId() != null) {
			transaction.setMaterial(materialService.findById(Material.class, transaction.getMaterial().getId()));
		}
		Page<Transaction> transactionlists = transactionService.findTransactionListByExample(page, getPageSize(),
				transaction, user.getId());
		// transactionService.findAllTransaction(page, getPageSize(),
		// user.getId());
		model.addAttribute("transaction", transaction);
		model.addAttribute("page", transactionlists);

		return "erp/alltransactionlist";
	}

	@RequestMapping("/savecreatetransactionsin")
	public String savecreateTransactionsin(Model model, @Valid @ModelAttribute("transaction") Transaction transaction, String materialidstring,
			Errors errors) {
		
		String custstring = transaction.getCustomer().getName();
		Customer trycustomer = new Customer();
		trycustomer.setName(custstring);
		List<Customer> customers = customerService.findAllByExample(trycustomer);
		if(customers!=null && customers.size()>0)
			trycustomer = customers.get(0);else{
				//create customer
				customerService.save(trycustomer);
			}
		transaction.setCustomer(trycustomer);
		ArrayList<MaterialOrder> list = new ArrayList();
		if (materialidstring != null && materialidstring != "") {// 拼接字符串，包含，id,
			// ordermaterialId,
			// orderThickness,
			// orderColor,
			// orderLength,
			// orderCount
			String[] ordermaterials = materialidstring.split(",");// 有效materials
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
							// mo.setJxforderid(workingorder.getId());
							// mo.setMaterialstatus("draft");
							// mo.setUpdatedBy(user);
							// mo.setUpdatedOn(new Date());
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

							// mo.setCreatedBy(user);
							// mo.setCreatedOn(new Date());
							// materialorderService.save(mo);

							list.add(mo);
						}
					}
				}
			}
		}
		
		String materialchildrenstring = "";
		String materialchildrencountstring = "";
		String materialtypestring = "";
		for (int j = 0; j < list.size(); j++) {

			MaterialOrder mo = list.get(j);
			if (j == 0) {
				materialchildrenstring = materialchildrenstring + mo.getMormgidentity();
				materialchildrencountstring = materialchildrencountstring + mo.getOrderCount();
				materialtypestring = materialtypestring + mo.getType();
			} else {
				materialchildrenstring = materialchildrenstring + "," + mo.getMormgidentity();
				materialchildrencountstring = materialchildrencountstring + "," + mo.getOrderCount();
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
			/*
			 * ArrayList<Integer> resultmaterialids = new ArrayList<Integer>();
			 * ArrayList<Integer> resultmaterialtranscounts = new
			 * ArrayList<Integer>(); for (int i = 0; i < allmaterialids.size();
			 * i++) { Integer id = allmaterialids.get(i);// this id; Integer
			 * tcount = materialtranscounts.get(i); if (i == 0) {
			 * resultmaterialids.add(id); resultmaterialtranscounts.add(tcount);
			 * } else {
			 * 
			 * for (int j = 0; j <= i; j++) { if (j < i) { if (id !=
			 * allmaterialids.get(j))// this id equals continue; // previous id
			 * else { int found = 0; for (int c = 0; c <
			 * resultmaterialids.size(); c++) { if (id ==
			 * resultmaterialids.get(c)) { resultmaterialtranscounts.set(c,
			 * resultmaterialtranscounts.get(c) + tcount); found = 1; break; } }
			 * if (found == 1) break; } } else { resultmaterialids.add(id);
			 * resultmaterialtranscounts.add(tcount); }
			 * 
			 * }
			 * 
			 * } }
			 * 
			 * // check materials stock, if all available, then transaction can
			 * be // done for (int i = 0; i < resultmaterialids.size(); i++) {
			 * Integer id = resultmaterialids.get(i); Integer transcount =
			 * resultmaterialtranscounts.get(i); Material ml =
			 * materialService.findById(Material.class, id); if (ml.getCount() <
			 * transcount) { errors.reject("validation.materialcount.invalid",
			 * "Check " + ml.getMaterialId() + " is out of stock!"); } } if
			 * (errors.hasErrors()) { return "erp/createtransactionsout"; }
			 */
			// do the transactions
			for (int c = 0; c < allmaterialids.size(); c++) {
				saveSimpleMaterial(transaction, allmaterialids.get(c), materialtranscounts.get(c), "IN");
			}
		}

		return "transactionSuccess";
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

	@RequestMapping("/savecreatetransactionsout")
	public String savecreateTransactionsout(Model model, @Valid @ModelAttribute("transaction") Transaction transaction,
			String materialidstring, Errors errors) {
		
		String custstring = transaction.getCustomer().getName();
		Customer trycustomer = new Customer();
		trycustomer.setName(custstring);
		List<Customer> customers = customerService.findAllByExample(trycustomer);
		if(customers!=null && customers.size()>0)
			trycustomer = customers.get(0);else{
				//create customer
				customerService.save(trycustomer);
			}
		transaction.setCustomer(trycustomer);
		
		
		ArrayList<MaterialOrder> list = new ArrayList();
		if (materialidstring != null && materialidstring != "") {// 拼接字符串，包含，id,
			// ordermaterialId,
			// orderThickness,
			// orderColor,
			// orderLength,
			// orderCount
			String[] ordermaterials = materialidstring.split(",");// 有效materials
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
							// mo.setJxforderid(workingorder.getId());
							// mo.setMaterialstatus("draft");
							// mo.setUpdatedBy(user);
							// mo.setUpdatedOn(new Date());
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

							// mo.setCreatedBy(user);
							// mo.setCreatedOn(new Date());
							// materialorderService.save(mo);

							list.add(mo);
						}
					}
				}
			}
		}
		
		String materialchildrenstring = transaction.getMaterialchildren();
		String materialchildrencountstring = transaction.getMaterialcount();
		String materialtypestring = transaction.getMaterialtype();
		for (int j = 0; j < list.size(); j++) {

			MaterialOrder mo = list.get(j);
			if (j == 0) {
				materialchildrenstring = materialchildrenstring + mo.getMormgidentity();
				materialchildrencountstring = materialchildrencountstring + mo.getOrderCount();
				materialtypestring = materialtypestring + mo.getType();
			} else {
				materialchildrenstring = materialchildrenstring + "," + mo.getMormgidentity();
				materialchildrencountstring = materialchildrencountstring + "," + mo.getOrderCount();
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
				}
			}
			if (errors.hasErrors()) {
				return "erp/createtransactionsout";
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

	@RequestMapping("searchelementtry")
	public String searchElementtry(Model model, @Valid @ModelAttribute Transaction transaction, Errors errors,
			String uiElement) {
		List<Material> materiallist = materialService.findAll(Material.class);
		List<MaterialGroup> materialgrouplist = materialgroupService.findAll(MaterialGroup.class);

		List<MaterialElement> elementList = new ArrayList<MaterialElement>();
		Iterator<Material> i1 = materiallist.iterator();
		while (i1.hasNext()) {
			Material material = i1.next();
			MaterialElement me = new MaterialElement();
			me = me.getElement(material);
			elementList.add(me);
		}
		Iterator<MaterialGroup> i2 = materialgrouplist.iterator();
		while (i2.hasNext()) {
			MaterialGroup materialgroup = i2.next();
			MaterialElement me = new MaterialElement();
			me = me.getElement(materialgroup);
			elementList.add(me);
		}

		MaterialElement me = new MaterialElement();
		model.addAttribute("elementList", elementList);
		model.addAttribute("uiElement", uiElement);
		model.addAttribute("element", me);
		return "erp/searchelementlist";
	}

	@RequestMapping("searchelement") // for search element when add
										// material/materialgroup
	public String searchElement(Model model, @Valid @ModelAttribute MaterialElement materialelement, Errors errors,
			String uiElement) {
		String elementid = materialelement.getElementId();
		Material m = new Material();
		m.setMaterialId(elementid);
		List<Material> materiallist = materialService.findAllByExample(m);

		MaterialGroup mg = new MaterialGroup();
		mg.setMaterialgroupId(elementid);

		List<MaterialGroup> materialgrouplist = materialgroupService.findAllByExample(mg);

		List<MaterialElement> elementList = new ArrayList<MaterialElement>();
		Iterator<Material> i1 = materiallist.iterator();
		while (i1.hasNext()) {
			Material material = i1.next();
			MaterialElement me = new MaterialElement();
			me = me.getElement(material);
			elementList.add(me);
		}
		Iterator<MaterialGroup> i2 = materialgrouplist.iterator();
		while (i2.hasNext()) {
			MaterialGroup materialgroup = i2.next();
			MaterialElement me = new MaterialElement();
			me = me.getElement(materialgroup);
			elementList.add(me);
		}

		MaterialElement me = new MaterialElement();
		model.addAttribute("elementList", elementList);
		model.addAttribute("uiElement", uiElement);
		model.addAttribute("element", me);
		return "erp/searchelementlist";
	}

}
