package com.jxf.oa.services;

import java.util.List;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.Order;


public interface OrderService extends BaseService {

	public Page<Order> findOrder(int pageIndex, int pageSize,int userId, boolean isClient,boolean isAdmin,String status) ;
	public Page<Order> findOrder(int pageIndex, int pageSize,int userId, boolean isClient,boolean isAdmin) ;
	public void saveSpiltOrder(int orderId, List orders,boolean isCopyEdit) ;
}
