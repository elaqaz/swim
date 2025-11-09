export interface Swimmer {
  id: number;
  first_name: string;
  last_name: string;
  dob: string;
  sex: 'M' | 'F';
  club: string;
  se_membership_id?: string;
  full_name?: string;
  created_at?: string;
  updated_at?: string;
}

export interface SwimmerWithPerformances extends Swimmer {
  performances: Performance[];
}

export interface Performance {
  id: number;
  swimmer_id: number;
  stroke: 'FREE' | 'BACK' | 'BREAST' | 'FLY' | 'IM';
  distance_m: 50 | 100 | 200 | 400 | 800 | 1500;
  course_type: 'LC' | 'SC';
  time_seconds: number;
  date: string;
  meet_name: string;
  venue?: string;
  license_level?: string;
  wa_points?: number;
  lc_time_seconds?: number;
  sc_time_seconds?: number;
  created_at?: string;
  updated_at?: string;
}

export interface PersonalBests {
  lc_performances: Performance[];
  sc_performances: Performance[];
}
