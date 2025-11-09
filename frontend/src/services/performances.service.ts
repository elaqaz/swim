import api from './api';

export const performancesService = {
  async import(swimmerId: number, historic: boolean = false): Promise<{ message: string }> {
    const response = await api.post('/performances/import', {
      swimmer_id: swimmerId,
      historic
    });
    return response.data;
  },

  async getHistory(seId: string, stroke: string, distanceM: number, courseType: string) {
    const response = await api.get(`/swimmers/${seId}/performances/${stroke}/${distanceM}/${courseType}`);
    return response.data;
  }
};
