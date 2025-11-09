import api from './api';

export interface QualificationCheckParams {
  dob: string;
  sex: 'M' | 'F';
  stroke: string;
  distance_m: number;
  time: string;
  course_type: 'LC' | 'SC';
}

export const publicService = {
  async checkQualification(params: QualificationCheckParams) {
    const response = await api.post('/check_qualification', params);
    return response.data;
  }
};
