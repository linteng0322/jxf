package com.jxf.oa.controller;

import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.Salesman;
import com.jxf.oa.entity.User;
import com.jxf.oa.services.SalesmanService;
import com.jxf.oa.services.UserService;

@Controller
@RequestMapping("/salesman")
public class SalesmanController extends BaseController {
	@Autowired
	protected SalesmanService salesmanService;

	@Autowired
	protected UserService userService;

	@RequestMapping("/allsalesman")
	public String findallsalesman(Model model, @RequestParam(required = false, defaultValue = "1") Integer page) {
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		Page<Salesman> salesmanlist = salesmanService.findAllSalesman(page, getPageSize(), user.getId());
		model.addAttribute("page", salesmanlist);
		return "erp/allsalesman";
	}

	@RequestMapping("/createsalesman")
	public String createsalesman(Model model, @Valid @ModelAttribute("salesman") Salesman salesman) {
		model.addAttribute("salesman", salesman);
		return "erp/createsalesman";
	}

	@RequestMapping("/editsalesman")
	public String editsalesman(Model model, @Valid @ModelAttribute("salesman") Salesman salesman) {
		salesman = salesmanService.findById(Salesman.class, salesman.getId());
		model.addAttribute("salesman", salesman);
		return "erp/createsalesman";
	}

	@RequestMapping("/savesalesman")
	public String savesalesman(Model model, @Valid @ModelAttribute("salesman") Salesman salesman) {
		if (salesman.getId() != null) {
			salesmanService.update(salesman);
		} else {
			salesmanService.save(salesman);
		}
		return "salesmansuccess";
	}

	@RequestMapping("/deletesalesman")
	public String deletesalesman(Model model, @Valid @ModelAttribute("salesman") Salesman salesman) {
		salesman = salesmanService.findById(Salesman.class, salesman.getId());
		salesmanService.delete(salesman);
		return "salesmansuccess";
	}
	
	@RequestMapping("/searchsalesman")
	public String searchsalesman(Model model, @Valid @ModelAttribute("salesman") Salesman salesman) {
		List<Salesman> salesmanlist = salesmanService.findAll(Salesman.class);
		model.addAttribute("salesmanlist", salesmanlist);
		model.addAttribute("salesman", salesman);
		return "erp/searchsalesmanlist";
	}

}
