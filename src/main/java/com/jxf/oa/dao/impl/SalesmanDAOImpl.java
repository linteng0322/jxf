package com.jxf.oa.dao.impl;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Projections;
import org.springframework.stereotype.Component;

import com.jxf.oa.bean.Page;
import com.jxf.oa.dao.SalesmanDAO;
import com.jxf.oa.entity.Salesman;

@Component
public class SalesmanDAOImpl extends BaseDAOImpl implements SalesmanDAO{

	    @Override
	    public int findTotalSize(Criteria criteria) {
	        criteria.setProjection(Projections.rowCount());
	        int totalSize =  ((Long)criteria.uniqueResult()).intValue();
	        criteria.setProjection(null);
	        return totalSize;
	    }

	    @Override
	    public Page<Salesman> findSalesman(int pageIndex, int pageSize, int userId) {

	        Criteria criteria = session().createCriteria(Salesman.class);
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

	        List<Salesman> salesmanlist = criteria.list();

	        return new Page<>(pageIndex, totalPage, pageSize, totalSize, salesmanlist);
       }
}