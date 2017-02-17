package com.jxf.oa.dao.impl;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Component;

import com.jxf.oa.bean.Page;
import com.jxf.oa.dao.CustomerDAO;
import com.jxf.oa.entity.Customer;

@Component
public class CustomerDAOImpl extends BaseDAOImpl implements CustomerDAO{

	    @Override
	    public int findTotalSize(Criteria criteria) {
	        criteria.setProjection(Projections.rowCount());
	        int totalSize =  ((Long)criteria.uniqueResult()).intValue();
	        criteria.setProjection(null);
	        return totalSize;
	    }

	    @Override
	    public Page<Customer> findCustomer(int pageIndex, int pageSize, int userId) {

	        Criteria criteria = session().createCriteria(Customer.class);
	        int totalSize = findTotalSize(criteria);
	        int totalPage = totalSize / pageSize;
	        if(totalSize % pageSize != 0) {
	            totalPage += 1;
	        }

	        if(pageIndex > totalPage) {
	            pageIndex = totalPage;
	        }

	        criteria.addOrder(org.hibernate.criterion.Order.desc("id"));
	        criteria.setFirstResult((pageIndex - 1) * pageSize);
	        criteria.setMaxResults(pageSize);

	        List<Customer> customers = criteria.list();

	        return new Page<>(pageIndex, totalPage, pageSize, totalSize, customers);
       }
	    
	    @Override
	    public List<Customer> findCustomersBySearchtext(String searchText) {
	    	if(searchText==null)
	    		searchText = "";

	        Criteria criteria = session().createCriteria(Customer.class);

	        criteria.addOrder(org.hibernate.criterion.Order.desc("id"));
	        criteria.add(Restrictions.or(Restrictions.like("phone", "%"+searchText+"%"), Restrictions.like("name", "%"+searchText+"%"), Restrictions.like("address", "%"+searchText+"%")));
	       

	        List<Customer> customers = criteria.list();

	        return customers;
       }

		@Override
		public List<Customer> findByCustomerName(String custname) {

	        Criteria criteria = session().createCriteria(Customer.class);

	        criteria.add(Restrictions.eq("name", custname));
	        List<Customer> customers = criteria.list();

	        return customers;
		}
	    
	    
}