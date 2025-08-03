package com.parcel.models;

import java.sql.Timestamp;

public class BaseModel {
	private Timestamp createdAt;
	private Timestamp updatedAt;

	public BaseModel() {
		this.createdAt = new Timestamp(System.currentTimeMillis());
		this.updatedAt = this.createdAt;
	}

	public BaseModel(Timestamp createdAt, Timestamp updatedAt) {
		this.createdAt = createdAt;
		this.updatedAt = updatedAt;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	public Timestamp getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Timestamp updatedAt) {
		this.updatedAt = updatedAt;
	}
}