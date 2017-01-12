package com.jxf.oa.services;

import org.springframework.security.core.userdetails.UserDetailsService;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.Salesman;

/**
 * Description Here
 *
 * @author Michael
 */
public interface SalesmanService extends BaseService, UserDetailsService {

	Page<Salesman> findAllSalesman(int pageIndex, int pageSize, int userId);
	
	
}
