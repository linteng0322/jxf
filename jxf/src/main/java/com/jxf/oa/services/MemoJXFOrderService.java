package com.jxf.oa.services;

import java.util.List;

import org.springframework.security.core.userdetails.UserDetailsService;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.MemoJXFOrder;

/**
 * Description Here
 *
 * @author Michael
 */
public interface MemoJXFOrderService extends BaseService, UserDetailsService {

	Page<MemoJXFOrder> findAllJxfOrder(int pageIndex, int pageSize, int userId);
	
	List<MemoJXFOrder> findJxfOrderListByExample(MemoJXFOrder order, int userId);
}
