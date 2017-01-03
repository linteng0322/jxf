package com.jxf.oa.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "TRANSACTION")
public class Transaction extends IdEntity {
	private Integer id;//auto generate
	private String type;//IN or OUT or RETURN
	private String orderNo;
	private Customer customer;
	private String contactPhone;//transaction contact phone not user's phone, can be blank, if same with customer's phone
	private Material material;
    private Integer count;
    private Double totalWeight;
    
    private String location;//location for customer's transaction
    private String materialchildren;//materialid for each out transaction
    private String materialcount;//materialcount for each out transaction
    private String materialtype;//material or materialgroup for each out transaction

    public Transaction() {
    }

    public Transaction(Integer id) {
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
    
    @Column(name = "TYPE", nullable = false, length = 20)
    public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	

	@Column(name = "ORDERNO")
	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	@ManyToOne
    @JoinColumn(name = "CUSTOMERID", nullable = false)
	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	@Column(name = "CONTACTPHONE")
	public String getContactPhone() {
		return contactPhone;
	}

	public void setContactPhone(String contactPhone) {
		this.contactPhone = contactPhone;
	}
	
	
	@ManyToOne
    @JoinColumn(name = "MATERIALID", nullable = false)
	public Material getMaterial() {
		return material;
	}

	public void setMaterial(Material material) {
		this.material = material;
	}
	
	
	@Column(name = "COUNT")
	public Integer getCount() {
		return count;
	}

	public void setCount(Integer count) {
		this.count = count;
	}
	
	
	public Double getTotalWeight() {
		if(this.count!=null&&this.material!=null&&this.material.getWeight()!=null&&this.material.getLength()!=null){
			return this.count*this.material.getWeight()*this.material.getLength();
		}
		return totalWeight;
	}

	public void setTotalWeight(Double totalWeight) {
		this.totalWeight = totalWeight;
	}

	@Column(name = "LOCATION")
	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getMaterialchildren() {
		return materialchildren;
	}

	public void setMaterialchildren(String materialchildren) {
		this.materialchildren = materialchildren;
	}

	public String getMaterialcount() {
		return materialcount;
	}

	public void setMaterialcount(String materialcount) {
		this.materialcount = materialcount;
	}

	public String getMaterialtype() {
		return materialtype;
	}

	public void setMaterialtype(String materialtype) {
		this.materialtype = materialtype;
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
		Transaction other = (Transaction) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		return true;
	}
	

}
