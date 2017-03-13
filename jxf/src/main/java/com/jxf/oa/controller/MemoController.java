package com.jxf.oa.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
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
import com.jxf.oa.entity.Memo;
import com.jxf.oa.entity.User;
import com.jxf.oa.services.CustomerService;
import com.jxf.oa.services.MaterialService;
import com.jxf.oa.services.MemoService;
import com.jxf.oa.services.SalesmanService;
import com.jxf.oa.services.TransactionService;
import com.jxf.oa.services.UserService;

@Controller
@RequestMapping("/memo")
public class MemoController extends BaseController {
	@Autowired
	protected MemoService memoService;
	
	@Autowired
	protected CustomerService customerService;

	@Autowired
	protected MaterialService materialService;

	@Autowired
	protected TransactionService transactionService;

	@Autowired
	protected UserService userService;

	@Autowired
	protected SalesmanService salesmanService;

	
	@RequestMapping("/creatememo")
	public String createMemo(Model model, @Valid @ModelAttribute Memo meo, Errors errors) {
		return "erp/creatememo";
	}
	@RequestMapping("/allmemo")
	public String findAllMemo(Model model, @RequestParam(required = false, defaultValue = "1") Integer page) {
		String TIME_FORMAT = "yyyyMMddHHmmssSSS";
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		SimpleDateFormat sf = new SimpleDateFormat(TIME_FORMAT);
		Page<Memo> memolist = memoService.findAllMemo(page, getPageSize(), user.getId());
		model.addAttribute("page", memolist);
		model.addAttribute("order", new Memo());
		return "erp/allmemolist";
	}

	@RequestMapping("/searchmemo")
	public String searchmemo(Model model, @Valid @ModelAttribute Memo memo, Errors errors) {
		String TIME_FORMAT = "yyyyMMddHHmmssSSS";
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		SimpleDateFormat sf = new SimpleDateFormat(TIME_FORMAT);
		List<Memo> memolist = memoService.findMemoListByExample(memo, user.getId());

		
		for (int i = 0; i < memolist.size(); i++) {
			Memo o = memolist.get(i);
			//if (o.getCalweight() != null)
				//listcalweight = listcalweight + o.getCalweight();
			
		}
		
		model.addAttribute("list", memolist);
		model.addAttribute("memo", memo);
		return "erp/searchmemo";
	}
	
	// use this for new and save
	@RequestMapping("/savecreatememo")
	public String savecreateOrder(Model model, @Valid @ModelAttribute Memo memo, String materialchildrenstring,
			Errors errors) {
		memoService.save(memo);
		return "redirect:/memo/allmemo";
	}
	
	@RequestMapping("/editmemo")
	public String editOrder(Model model, @Valid @ModelAttribute Memo memo, String materialchildrenstring,
			Errors errors) {
		Memo thismemo = memoService.findById(Memo.class, memo.getId());
		model.addAttribute("memo", thismemo);
		return "erp/editmemo";
	}
	
	@RequestMapping("/saveeditmemo")
	public String saveeditMemo(Model model, @Valid @ModelAttribute Memo memo, String materialchildrenstring,
			Errors errors) {
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		memo.setUpdatedOn(new Date());
		memo.setUpdatedBy(user);
		memoService.update(memo);
		return "redirect:/memo/allmemo";
	}

	@RequestMapping("/deletememo")
	public String deleteMemo(Model model, @Valid @ModelAttribute Memo memo, String materialchildrenstring,
			Errors errors) {
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		memo = memoService.findById(Memo.class, memo.getId());
		memoService.delete(memo);
		return "redirect:/memo/allmemo";
	}

}
