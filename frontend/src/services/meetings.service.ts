import api from './api';
import type { Meeting, ParsedMeetDatum } from '../types/meeting.types';

export const meetingsService = {
  async getAll(): Promise<Meeting[]> {
    const response = await api.get('/meetings');
    return response.data;
  },

  async getById(id: number) {
    const response = await api.get(`/meetings/${id}`);
    return response.data;
  },

  async uploadPDF(file: File): Promise<{ message: string; parsed_record_id: number }> {
    const formData = new FormData();
    formData.append('pdf_file', file);

    const response = await api.post('/meetings', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
    return response.data;
  },

  async getStatus(id: number): Promise<ParsedMeetDatum> {
    const response = await api.get(`/meetings/${id}/status`);
    return response.data;
  },

  async review(id: number) {
    const response = await api.get(`/meetings/${id}/review`);
    return response.data;
  },

  async confirm(id: number) {
    const response = await api.post(`/meetings/${id}/confirm`);
    return response.data;
  },

  async compare(id: number, swimmerIds?: number[]) {
    const params = swimmerIds ? { swimmer_ids: swimmerIds } : {};
    const response = await api.get(`/meetings/${id}/compare`, { params });
    return response.data;
  },

  async getSwimmerTimeHistory(id: number, swimmerId: number, stroke: string, distanceM: number) {
    const response = await api.get(`/meetings/${id}/swimmer_time_history`, {
      params: {
        swimmer_id: swimmerId,
        stroke,
        distance_m: distanceM
      }
    });
    return response.data;
  },

  async downloadPDF(id: number): Promise<Blob> {
    const response = await api.get(`/meetings/${id}/download_pdf`, {
      responseType: 'blob'
    });
    return response.data;
  },

  async delete(id: number): Promise<{ message: string }> {
    const response = await api.delete(`/meetings/${id}`);
    return response.data;
  }
};
