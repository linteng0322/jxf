package com.jxf.oa.services;

import org.springframework.security.core.userdetails.UserDetailsService;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.MaterialOrder;

/**
 * Description Here
 *
 * @author Michael
 */
public interface MaterialOrderService extends BaseService, UserDetailsService {

	Page<MaterialOrder> findAllMaterialOrder(int pageIndex, int pageSize, int userId);
	
	
}
