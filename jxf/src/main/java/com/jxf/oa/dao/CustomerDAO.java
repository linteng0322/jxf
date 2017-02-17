package com.jxf.oa.dao;

import java.util.List;

import org.hibernate.Criteria;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.Customer;

public interface CustomerDAO extends BaseDAO {
    
	public int findTotalSize(Criteria criteria);

    public Page<Customer> findCustomer(int pageIndex, int pageSize, int userId);

	List<Customer> findCustomersBySearchtext(String searchtext);

	public List<Customer> findByCustomerName(String custname);
    
}
