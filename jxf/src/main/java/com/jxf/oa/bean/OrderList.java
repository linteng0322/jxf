package com.jxf.oa.bean;

import java.io.Serializable;
import java.util.List;

import com.jxf.oa.entity.Order;

public class OrderList implements Serializable{
    private List<Order> orders;
	public OrderList() {
		
	}
	public List<Order> getOrders() {
		return orders;
	}
	public void setOrders(List<Order> orders) {
		this.orders = orders;
	}

	
}
