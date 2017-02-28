package com.jxf.oa.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.hibernate.Criteria;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Component;

import com.jxf.oa.bean.Page;
import com.jxf.oa.dao.MemoJXFOrderDAO;
import com.jxf.oa.entity.MemoJXFOrder;

@Component
public class MemoJXFOrderDAOImpl extends BaseDAOImpl implements MemoJXFOrderDAO {

	@Override
	public int findTotalSize(Criteria criteria) {
		criteria.setProjection(Projections.rowCount());
		int totalSize = ((Long) criteria.uniqueResult()).intValue();
		criteria.setProjection(null);
		return totalSize;
	}

	@Override
	public Page<MemoJXFOrder> findJxfOrder(int pageIndex, int pageSize, int userId) {

		Criteria criteria = session().createCriteria(MemoJXFOrder.class);
		int totalSize = findTotalSize(criteria);
		int totalPage = totalSize / pageSize;
		if (totalSize % pageSize != 0) {
			totalPage += 1;
		}

		if (pageIndex > totalPage) {
			pageIndex = totalPage;
		}

		criteria.addOrder(org.hibernate.criterion.Order.desc("id"));
		criteria.setFirstResult((pageIndex - 1) * pageSize);
		criteria.setMaxResults(pageSize);
		//criteria.setResultTransformer(criteria.DISTINCT_ROOT_ENTITY); 
		List<MemoJXFOrder> jxforders = criteria.list();

		return new Page<>(pageIndex, totalPage, pageSize, totalSize, jxforders);
	}

	@Override
	public List<MemoJXFOrder> findJxfOrderListByExample(MemoJXFOrder order, int userId) {
		// TODO Auto-generated method stub
		Criteria criteria = session().createCriteria(MemoJXFOrder.class);
		if (order.getOrderId() != null && order.getOrderId() != "")
			criteria.add(Restrictions.eq("orderId", order.getOrderId()));
		if (order.getJxforderstatus() != null && order.getJxforderstatus() != "")
			criteria.add(Restrictions.eq("jxforderstatus", order.getJxforderstatus()));
		if (order.getIspaid() != null)
			criteria.add(Restrictions.eq("ispaid", order.getIspaid()));
		if (order.getCustomer() != null && order.getCustomer().getId() != null)
			criteria.add(Restrictions.eq("customer.id", order.getCustomer().getId()));
		if (order.getSalesman() != null && order.getSalesman().getId() != null)
			criteria.add(Restrictions.eq("salesman.id", order.getSalesman().getId()));
		if (order.getFromdate() != null && order.getTodate() != null && order.getFromdate() != ""
				&& order.getTodate() != "") {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			try {
				Date fromdate = sdf.parse(order.getFromdate());
				Date todate = sdf.parse(order.getTodate());
				criteria.add(Restrictions.between("createdOn", fromdate, todate));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		int totalSize = findTotalSize(criteria);

		criteria.addOrder(org.hibernate.criterion.Order.desc("id"));
		criteria.setResultTransformer(criteria.DISTINCT_ROOT_ENTITY); 
		List<MemoJXFOrder> jxforders = criteria.list();
		return jxforders;
	}
}