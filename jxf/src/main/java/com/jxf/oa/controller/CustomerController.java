package com.jxf.oa.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.validation.Valid;

import org.apache.commons.lang.StringUtils;
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
import com.jxf.oa.bean.SelectLabelBean;
import com.jxf.oa.entity.Customer;
import com.jxf.oa.entity.Material;
import com.jxf.oa.entity.MaterialGroup;
import com.jxf.oa.entity.MaterialOrder;
import com.jxf.oa.entity.User;
import com.jxf.oa.services.CustomerService;
import com.jxf.oa.services.UserService;
import com.jxf.oa.util.LangUtil;

@Controller
@RequestMapping("/customer")
public class CustomerController extends BaseController {
	@Autowired
	protected CustomerService customerService;

	@Autowired
	protected UserService userService;

	@RequestMapping("/customerlist")
	public String list(Model model, @RequestParam(required = false, defaultValue = "1") Integer page) {
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;

		Page<Customer> customerlists = customerService.findAllCustomer(page, getPageSize(), user.getId());
		model.addAttribute("page", customerlists);
		return "erp/customerlist";
	}

	@RequestMapping("/allcustomerlist")
	public String allCustomerList(Model model, @RequestParam(required = false, defaultValue = "1") Integer page) {
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		Page<Customer> customerlists = customerService.findAllCustomer(page, getPageSize(), user.getId());
		model.addAttribute("page", customerlists);
		model.addAttribute("customer", new Customer());
		
		return "erp/allcustomerlist";
	}

	@RequestMapping("/createcustomer")
	public String createCustomer(Model model, @Valid @ModelAttribute Customer customer, Errors errors) {
		return "erp/createcustomer";
	}

	@RequestMapping("/savecreatecustomer")
	public String savecreateCustomer(Model model, @Valid @ModelAttribute("customer") Customer customer, Errors errors) {
		if (StringUtils.isBlank(customer.getName())) {
			String name = LangUtil.getMessage("label.client", ctx);
			errors.reject("validation.required", new String[] { name }, "Name is requried");
		}
		
		String custname = customer.getName();
		Customer trycustomer = new Customer();
		trycustomer.setName(custname);
		List trycustomers = customerService.findAllByExample(trycustomer);
		if(trycustomers !=null){
			errors.reject("validation.exist", new String[] { custname }, "Name already exits!");
		}

		if (errors.hasErrors()) {
			return "erp/createcustomer";
		}

		SimpleDateFormat dateformat1 = new SimpleDateFormat("yyyyMMddHHmmss");
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;

		
		customer.setCreatedBy(user);
		customer.setCreatedOn(new Date());
		customer.setUpdatedBy(user);
		customer.setUpdatedOn(new Date());
		customerService.save(customer);

		return "customerSuccess";
	}

	@RequestMapping("editcustomer")
	public String editCustomer(Model model, Customer customer, Errors errors) {
		customer = customerService.findById(Customer.class, customer.getId());
		model.addAttribute("customer", customer);
		return "erp/editcustomer";
	}

	@RequestMapping("/saveeditcustomer")
	public String saveeditCustomer(Model model, @Valid @ModelAttribute("customer") Customer customer, Errors errors) {
		SimpleDateFormat dateformat1 = new SimpleDateFormat("yyyyMMddHHmmss");
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		customer.setUpdatedBy(user);
		customer.setUpdatedOn(new Date());
		customerService.update(customer);

		return "customerSuccess";
	}
	
	@RequestMapping("/deletecustomer")
    public String deleteCustomer(@RequestParam Integer id) {
        Customer customer = new Customer();
        customer.setId(id);
        try {
            customerService.delete(customer);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/customer/allcustomerlist/";
    }

	// for pop up of transaction
	@RequestMapping("searchcustomer")
	public String searchCustomer(Model model, @Valid @ModelAttribute("customer") Customer customer, Errors errors) {
		List<Customer> customerList = customerService.findAllByExample(customer);
		model.addAttribute("customerlist", customerList);
		model.addAttribute("customer", customer);
		return "erp/searchcustomerlist";
	}
	
	@RequestMapping("searchcustomerlist")
	public String searchCustomerList(Model model, @Valid @ModelAttribute("customer") Customer customer, Errors errors) {
		List<Customer> customerList = customerService.findAllByExample(customer);
		model.addAttribute("customerlist", customerList);
		model.addAttribute("customer", customer);
		return "erp/allcustomerlist";
	}
	
	@RequestMapping(value="searchcustomersbysearchtext")
	//@RequestMapping(value="searchcustomersbysearchtext" , produces="text/html;charset=UTF-8;")
	@ResponseBody
	public List getCustomersbysearchtext(Model model, String searchText){
		HashMap hmap = new HashMap();
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		List<Customer> list = customerService.findCustomersBySearchtext(searchText);
		if(list!=null&&list.size()>0)
			hmap.put(1, list.get(0));
		
		List searchcustomerlist = new ArrayList();
		for(int i = 0; i<list.size(); i++){
			Customer customer = list.get(i);
			searchcustomerlist.add(new SelectLabelBean(customer.getId()+"", customer.getName()+customer.getPhone()+customer.getAddress()+""));
		}
		
		model.addAttribute("searchcustomerlist", searchcustomerlist);
		
		return list;
	}
	
	@RequestMapping(value="getallcustomer" , produces="text/html;charset=UTF-8;")
	@ResponseBody
	public String getallmaterialorder() {
		String customers = "";
		List<Customer> clist = materialService.findAll(Customer.class);
		for (int i =0; i<clist.size(); i++){
			Customer customer = clist.get(i);
			if(i==0){
				customers= customer.getName();//+";"+customer.getPhone()+";"+customer.getAddress();
			}else{
				customers= customers + "," + customer.getName();//+";"+customer.getPhone()+";"+customer.getAddress();
			}
			
		}
		
		return customers;
	}
	
}
