package com.jxf.oa.services;

import java.util.List;

import org.springframework.security.core.userdetails.UserDetailsService;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.JXFOrder;

/**
 * Description Here
 *
 * @author Michael
 */
public interface JXFOrderService extends BaseService, UserDetailsService {

	Page<JXFOrder> findAllJxfOrder(int pageIndex, int pageSize, int userId);
	
	List<JXFOrder> findJxfOrderListByExample(JXFOrder order, int userId);
}
