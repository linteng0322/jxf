package com.jxf.oa.entity;

import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "JXFORDER")
public class JXFOrder extends IdEntity {

	private Integer id;
	private String orderId;// auto generated based on time;
	private Customer customer;
	private Salesman salesman;
	private String calweight;// estimated weight of the whole order
	private Double actweight;// actual weight of the whole order
	private String unitprice;// actual weight of the whole order
	private Double actincome;// actual weight of the materials
	private Double additionalincome;
	private Double totalincome;// total income = materials+additional
	private String jxforderstatus;// draft:new created; allset:all materials
									// set; partial: part of materials out; completed: all materials out
	private Boolean ispaid;
	private String fromdate;
	private String todate;
	private List<MaterialOrder> materialorderlist;
	private String additionalmaterialstring;

	private String memo;
	private String expressinfo;
	
	private String materialorderpricestring;//save all unit price of all types
	private String materialorderliststring;//for display of all materialorder
	
	public JXFOrder() {
	}

	public JXFOrder(Integer id) {
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

	@Column(name = "ORDERID")
	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	@ManyToOne
	@JoinColumn(name = "CUSTOMERID", nullable = false)
	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	@ManyToOne
	@JoinColumn(name = "SALESMANID")
	public Salesman getSalesman() {
		return salesman;
	}

	public void setSalesman(Salesman salesman) {
		this.salesman = salesman;
	}

	@Column(name = "CALWEIGHT")
	public String getCalweight() {
		return calweight;
	}

	public void setCalweight(String calweight) {
		this.calweight = calweight;
	}
	
	

	@Column(name = "ACTWEIGHT")
	public Double getActweight() {
		return actweight;
	}

	public void setActweight(Double actweight) {
		this.actweight = actweight;
	}

	@Column(name = "UNITPRICE")
	public String getUnitprice() {
		return unitprice;
	}

	public void setUnitprice(String unitprice) {
		this.unitprice = unitprice;
	}
	
	

	@Column(name = "ACTINCOME")
	public Double getActincome() {
		return actincome;
	}

	public void setActincome(Double actincome) {
		this.actincome = actincome;
	}

	@Column(name = "ADDITIONALINCOME")
	public Double getAdditionalincome() {
		return additionalincome;
	}

	public void setAdditionalincome(Double additionalincome) {
		this.additionalincome = additionalincome;
	}

	@Column(name = "TOTALINCOME")
	public Double getTotalincome() {
		return totalincome;
	}

	public void setTotalincome(Double totalincome) {
		this.totalincome = totalincome;
	}

	@Column(name = "STATUS")
	public String getJxforderstatus() {
		return jxforderstatus;
	}

	public void setJxforderstatus(String jxforderstatus) {
		this.jxforderstatus = jxforderstatus;
	}

	@Column(name = "ISPAID")
	public Boolean getIspaid() {
		return ispaid;
	}

	public void setIspaid(Boolean ispaid) {
		this.ispaid = ispaid;
	}

	public String getFromdate() {
		return fromdate;
	}

	public void setFromdate(String fromdate) {
		this.fromdate = fromdate;
	}

	public String getTodate() {
		return todate;
	}

	public void setTodate(String todate) {
		this.todate = todate;
	}

	@OneToMany(cascade = CascadeType.REMOVE, fetch = FetchType.LAZY, mappedBy = "jxforderid")
	public List<MaterialOrder> getMaterialorderlist() {
		return materialorderlist;
	}

	public void setMaterialorderlist(List<MaterialOrder> materialorderlist) {
		this.materialorderlist = materialorderlist;
	}

	@Column(name = "ADDITIONALMATERIAL")
	public String getAdditionalmaterialstring() {
		return additionalmaterialstring;
	}

	public void setAdditionalmaterialstring(String additionalmaterialstring) {
		this.additionalmaterialstring = additionalmaterialstring;
	}

	@Column(name = "MEMO")
	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	@Column(name = "EXPRESSINFO")
	public String getExpressinfo() {
		return expressinfo;
	}

	public void setExpressinfo(String expressinfo) {
		this.expressinfo = expressinfo;
	}
	
	
	@Column(name = "MATERIALORDERPRICE")
	public String getMaterialorderpricestring() {
		return materialorderpricestring;
	}
	
	public void setMaterialorderpricestring(String materialorderpricestring) {
		this.materialorderpricestring = materialorderpricestring;
	}

	public String getMaterialorderliststring() {
		return materialorderliststring;
	}

	public void setMaterialorderliststring(String materialorderliststring) {
		this.materialorderliststring = materialorderliststring;
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
		JXFOrder other = (JXFOrder) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		return true;
	}

}
