package com.jxf.oa.services;

import java.util.List;

import org.springframework.security.core.userdetails.UserDetailsService;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.Customer;

/**
 * Description Here
 *
 * @author Michael
 */
public interface CustomerService extends BaseService, UserDetailsService {

	Page<Customer> findAllCustomer(int pageIndex, int pageSize, int userId);

	List<Customer> findCustomersBySearchtext(String searchText);
	
	
}
