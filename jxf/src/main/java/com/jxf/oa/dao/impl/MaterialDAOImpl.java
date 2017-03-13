package com.jxf.oa.dao.impl;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Component;

import com.jxf.oa.bean.Page;
import com.jxf.oa.dao.MaterialDAO;
import com.jxf.oa.dao.OrderDAO;
import com.jxf.oa.entity.Material;
import com.jxf.oa.entity.Order;
import com.jxf.oa.entity.User;
import com.jxf.oa.util.LangUtil;

import java.util.List;

@Component
public class MaterialDAOImpl extends BaseDAOImpl implements MaterialDAO{

	    @Override
	    public int findTotalSize(Criteria criteria) {
	        criteria.setProjection(Projections.rowCount());
	        int totalSize =  ((Long)criteria.uniqueResult()).intValue();
	        criteria.setProjection(null);
	        return totalSize;
	    }

	    @Override
	    public Page<Material> findMaterial(Material material, int pageIndex, int pageSize, int userId) {

	        Criteria criteria = session().createCriteria(Material.class);
	        
	        if(material !=null && material.getMaterialId()!=null&&material.getMaterialId()!=""){
	        	criteria.add(Restrictions.eq("materialId", material.getMaterialId()));
	        }
	        
	        int totalSize = findTotalSize(criteria);
	        int totalPage = totalSize / pageSize;
	        if(totalSize % pageSize != 0) {
	            totalPage += 1;
	        }

	        if(pageIndex > totalPage) {
	            pageIndex = totalPage;
	        }

	        criteria.addOrder(org.hibernate.criterion.Order.asc("materialId"));
	        criteria.addOrder(org.hibernate.criterion.Order.asc("thickness"));
	        criteria.addOrder(org.hibernate.criterion.Order.asc("color"));
	        criteria.addOrder(org.hibernate.criterion.Order.asc("length"));
	        criteria.setFirstResult((pageIndex - 1) * pageSize);
	        criteria.setMaxResults(pageSize);

	        List<Material> materials = criteria.list();

	        return new Page<>(pageIndex, totalPage, pageSize, totalSize, materials);
       }
}