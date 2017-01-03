package com.jxf.oa.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.validator.constraints.NotBlank;

@Entity
@Table(name = "MATERIALORDER")
public class MaterialOrder extends IdEntity {

	private Integer id;
	private Integer jxforderid;// 订单编号

	private String type;// material or materialgroup
	private Integer mormgidentity;
	private String materialstatus;// draft; set

	private String orderMaterialId;
	private String orderPinming;
	private Double orderThickness;
	private Double orderLength;
	private String orderColor;
	private Double materialWeight;//相应的物料length*weight
	private Integer orderCount;

	public MaterialOrder() {
	}

	public MaterialOrder(Integer id) {
		this.id = id;
	}

	@Id
	@Column(name = "ID")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	
	@Column(name = "ORDERID", nullable = false)
	public Integer getJxforderid() {
		return jxforderid;
	}

	public void setJxforderid(Integer jxforderid) {
		this.jxforderid = jxforderid;
	}

	
	@Column(name = "TYPE")
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	@Column(name = "MORMGIDENTITY")
	public Integer getMormgidentity() {
		return mormgidentity;
	}

	public void setMormgidentity(Integer mormgidentity) {
		this.mormgidentity = mormgidentity;
	}

	@Column(name = "MATERIALSTATUS")
	public String getMaterialstatus() {
		return materialstatus;
	}

	public void setMaterialstatus(String materialstatus) {
		this.materialstatus = materialstatus;
	}

	@Column(name = "ORDERMATERIALID")
	public String getOrderMaterialId() {
		return orderMaterialId;
	}

	public void setOrderMaterialId(String orderMaterialId) {
		this.orderMaterialId = orderMaterialId;
	}

	@Column(name = "ORDERPINMING")
	public String getOrderPinming() {
		return orderPinming;
	}

	public void setOrderPinming(String orderPinming) {
		this.orderPinming = orderPinming;
	}

	@Column(name = "ORDERTHICKNESS")
	public Double getOrderThickness() {
		return orderThickness;
	}

	public void setOrderThickness(Double orderThickness) {
		this.orderThickness = orderThickness;
	}

	@Column(name = "ORDERLENGTH")
	public Double getOrderLength() {
		return orderLength;
	}

	public void setOrderLength(Double orderLength) {
		this.orderLength = orderLength;
	}

	@Column(name = "ORDERCOLOR")
	public String getOrderColor() {
		return orderColor;
	}

	public void setOrderColor(String orderColor) {
		this.orderColor = orderColor;
	}
	
	@Column(name = "ORDERMATERIALWEIGHT")
	public Double getMaterialWeight() {
		return materialWeight;
	}

	public void setMaterialWeight(Double materialWeight) {
		this.materialWeight = materialWeight;
	}

	@Column(name = "ORDERCOUNT")
	public Integer getOrderCount() {
		return orderCount;
	}

	public void setOrderCount(Integer orderCount) {
		this.orderCount = orderCount;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		return result;
	}
	

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		MaterialOrder other = (MaterialOrder) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		return true;
	}

}
