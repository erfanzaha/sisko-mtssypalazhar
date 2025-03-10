<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * CMS Sekolahku Premium Version
 * @version    2.5.4
 * @author     Anton Sofyan | https://facebook.com/antonsofyan | 4ntonsofyan@gmail.com | 0857 5988 8922
 * @copyright  (c) 2017-2023
 * @link       https://sekolahku.web.id
 *
 * PERINGATAN :
 * 1. TIDAK DIPERKENANKAN MENGGUNAKAN CMS INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 2. TIDAK DIPERKENANKAN MEMPERJUALBELIKAN APLIKASI INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 3. TIDAK DIPERKENANKAN MENGHAPUS KODE SUMBER APLIKASI.
 */

class M_meeting_attendences extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'meeting_attendences';
	
	/**
	 * Insert Meeting Attendance
	 * @param Integer $class_meeting_id
	 * @param Integer $academic_year_id
	 * @param Integer $class_group_id
	 * @return Boolean
	 */
	public function insert($class_meeting_id, $academic_year_id, $class_group_id) {
		$students = $this->db
			->select('x1.student_id')
			->join('class_group_settings x2', 'x1.class_group_setting_id = x2.id', 'LEFT')
			->join('users x3', 'x1.student_id = x3.id', 'LEFT')
			->where('x2.academic_year_id', $academic_year_id)
			->where('x2.class_group_id', $class_group_id)
			->get('class_group_students x1');
		foreach($students->result() as $row) {
			if ( ! $this->is_exists($class_meeting_id, $row->student_id)) {
				$dataset = [
					'class_meeting_id' => $class_meeting_id,
					'student_id' => $row->student_id,
					'presence' => 'present',
					'note' => '',
					'created_by' => (int) __session('user_id')
				];
				$this->db->insert('meeting_attendences', $dataset);
			}
		}
		return TRUE;
	}

	/**
	 * Update Meeting Attendance
	 * @param Array $meeting_attendences
	 * @return Boolean
	 */
	public function update($meeting_attendences) {
		$success = 0;
		foreach ($meeting_attendences as $row) {
			$dataset = [
				'updated_by' => __session('user_id'),
				'presence' => $row['presence']
			];
			$id = $row['id'];
			$query = $this->db
				->where('id', $id)
				->update(self::$table, $dataset);
			if ($query) {
				$success++;
			}
		}
		return $success > 0;
	}

	/**
	 * Is Exist Meeting Attendance
	 * @param Integer $class_meeting_id
	 * @param Integer $student_id
	 * @return Boolean
	 */
	private function is_exists($class_meeting_id, $student_id) {
		$count = $this->db
			->where('class_meeting_id', $class_meeting_id)
			->where('student_id', $student_id)
			->count_all_results(self::$table);
		return $count === 1;
	}

	/**
	 * Get Meeting Attendance
	 * @param Integer $class_meeting_id
	 * @return Array
	 */
	public function get_meeting_attendences($class_meeting_id) {
		$query = $this->db
			->select("
				x1.id
				, x2.nis
				, x2.full_name
				, IF(x2.gender = 'M', 'L', 'P') AS gender
				, x1.presence
				, x1.note
			")
			->join('users x2', 'ON x1.student_id = x2.id', 'LEFT')
			->where('x1.class_meeting_id', $class_meeting_id)
			->get(self::$table.' x1');
		$data = [];
		foreach ($query->result() as $row) {
			$data[] = [
				'id' => $row->id,
				'nis' => $row->nis,
				'full_name' => $row->full_name,
				'gender' => $row->gender,
				'presence' => $row->presence,
				'note' => $row->note
			];
		}
		return $data;
	}

	/**
	 * Get Data
	 * @param String $keyword
	 * @param String $return_type
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function get_where($keyword = '', $return_type = 'count', $limit = 0, $offset = 0) {
		$this->db->select("
			x1.id
		  , x5.nis
		  , x5.full_name
		  , IF(x5.gender = 'M', 'L', 'P') AS gender
		  , x6.academic_year
		  , IF(x3.semester = 'odd', 'Ganjil', 'Genap') AS semester
		  , CONCAT(x7.class_group, IF((x8.major_short_name <> ''), CONCAT(' ',x8.major_short_name),''),IF((x7.sub_class_group <> ''),CONCAT(' - ',x7.sub_class_group),'')) AS class_name
		  , x2.date
		  , x4.subject_name
		  , x2.start_time
		  , x2.end_time
		  , CASE WHEN x1.presence = 'present' THEN 'H'
		    WHEN x1.presence = 'sick' THEN 'S'
		    WHEN x1.presence = 'permit' THEN 'I'
		    WHEN x1.presence = 'absent' THEN 'A'
		    END AS presence
		");
		$this->db->join('class_meetings x2', 'x1.class_meeting_id = x2.id', 'LEFT');
		$this->db->join('course_classes x3', 'x2.course_class_id = x3.id', 'LEFT');
		$this->db->join('subjects x4', 'x3.subject_id = x4.id', 'LEFT');
		$this->db->join('users x5', 'x1.student_id = x5.id', 'LEFT');
		$this->db->join('academic_years x6', 'x3.academic_year_id = x6.id', 'LEFT');
		$this->db->join('class_groups x7', 'x3.class_group_id = x7.id', 'LEFT');
		$this->db->join('majors x8', 'x7.major_id = x8.id', 'LEFT');
		if ( ! empty($keyword) ) {
			$this->db->like('x5.nis', $keyword);
			$this->db->or_like('x5.full_name', $keyword);
			$this->db->or_like('x5.gender', (strtolower($keyword) == 'ganjil' ? 'odd':'even'));
			$this->db->or_like('x6.academic_year', $keyword);
			$this->db->or_like('x3.semester', $keyword);
			$this->db->or_like("CONCAT(x7.class_group, IF((x8.major_short_name <> ''), CONCAT(' ',x8.major_short_name),''),IF((x7.sub_class_group <> ''),CONCAT(' - ',x7.sub_class_group),''))", $keyword);
			$this->db->or_like('x2.date', $keyword);
			$this->db->or_like('x4.subject_name', $keyword);
			$this->db->or_like('x2.start_time', $keyword);
			$this->db->or_like('x2.end_time', $keyword);
			$this->db->or_like('x1.presence', ($keyword == 'H' ? 'present' : ($keyword == 'S' ? 'sick' : ($keyword == 'I' ? 'permit' : ($keyword == 'A' ? 'absent' : 'NA')))));
		}
		if ( $return_type === 'count' ) return $this->db->count_all_results(self::$table . ' x1');
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table . ' x1');
	}

	/**
	 * Get Student Presence Report
	 * @param String $keyword
	 * @param String $return_type
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function student_presence_report($keyword = '', $return_type = 'count', $limit = 0, $offset = 0) {
		$this->db->select("
			x1.id
		  , x2.date
		  , x2.start_time
		  , x2.end_time
		  , x4.subject_name
		  , x5.full_name AS teacher
		  , x2.discussion
		  , CASE WHEN x1.presence = 'present' THEN 'H'
		    WHEN x1.presence = 'sick' THEN 'S'
		    WHEN x1.presence = 'permit' THEN 'I'
		    WHEN x1.presence = 'absent' THEN 'A'
		    END AS presence
		");
		$this->db->join('class_meetings x2', 'x1.class_meeting_id = x2.id', 'LEFT');
		$this->db->join('course_classes x3', 'x2.course_class_id = x3.id', 'LEFT');
		$this->db->join('subjects x4', 'x3.subject_id = x4.id', 'LEFT');
		$this->db->join('users x5', 'x3.employee_id = x5.id', 'LEFT');
		$this->db->where('x1.student_id', (int) __session('user_id'));
		$this->db->where('x3.academic_year_id', (int) __session('current_academic_year_id'));
		$this->db->where('x3.semester', __session('current_academic_semester'));
		if ( ! empty($keyword) ) {
			$this->db->group_start();
			$this->db->like('x2.date', $keyword);
			$this->db->or_like('x2.start_time', $keyword);
			$this->db->or_like('x2.end_time', $keyword);
			$this->db->or_like('x4.subject_name', $keyword);
			$this->db->or_like('x5.full_name', $keyword);
			$this->db->or_like('x2.discussion', $keyword);
			$this->db->or_like('x1.presence', ($keyword == 'H' ? 'present' : ($keyword == 'S' ? 'sick' : ($keyword == 'I' ? 'permit' : ($keyword == 'A' ? 'absent' : 'NA')))));
			$this->db->group_end();
		}
		$this->db->order_by('x2.date', 'DESC');
		$this->db->order_by('x2.start_time', 'ASC');
		if ( $return_type === 'count' ) return $this->db->count_all_results(self::$table . ' x1');
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table. ' x1');
	}

	/**
	 * Get Semester Attendance Report
	 * @param Integer $academic_year_id
	 * @param String $semester
	 * @param Integer $class_group_id
	 * @return Array
	 */
	public function get_semester_attendance_report($academic_year_id, $semester, $class_group_id) {
		$query = $this->db->query("
			SELECT x5.nis
			  , x5.full_name
			  , x5.gender
			  , CASE WHEN x5.presence LIKE '%present%' THEN 'H'
			    WHEN x5.presence = 'sick' THEN 'S'
			    WHEN x5.presence = 'permit' THEN 'I'
			    WHEN x5.presence = 'absent' THEN 'A'
			    ELSE 'NA'
			    END AS presence
			FROM (
			  SELECT x4.nis
			    , x4.full_name
			    , IF(x4.gender = 'M', 'L', 'P') AS gender
			    , GROUP_CONCAT(DISTINCT x3.presence) AS presence
			  FROM class_meetings x1
			  LEFT JOIN course_classes x2
			    ON x1.course_class_id = x2.id
			  LEFT JOIN meeting_attendences x3
			    ON x1.id= x3.class_meeting_id
			  LEFT JOIN users x4
			    ON x3.student_id = x4.id
			  WHERE x2.academic_year_id = ?
			  AND x2.semester = ?
			  AND x2.class_group_id = ?
			  GROUP BY 1,2,3
			) x5
			GROUP BY 1,2,3
			ORDER BY 2,1 ASC
		", [$academic_year_id, $semester, $class_group_id]);
		$data = [];
		foreach($query->result() as $row) {
			$data[] = [
				'nis' => $row->nis,
				'full_name' => $row->full_name,
				'gender' => $row->gender,
				'presence' => $row->presence
			];
		}

		return $data;
	}

	/**
	 * Get Daily Report
	 * @param Integer $academic_year_id
	 * @param String $semester
	 * @param Integer $class_group_id
	 * @param String $start_date
	 * @param String $end_date
	 * @return Resource
	 */
	public function get_daily_attendance_report($academic_year_id, $semester, $class_group_id, $start_date, $end_date) {
		$query = $this->db->query("
			SELECT x5.date
			  , x5.nis
			  , x5.full_name
			  , x5.gender
			  , CASE WHEN x5.presence LIKE '%present%' THEN 'H'
			    WHEN x5.presence = 'sick' THEN 'S'
			    WHEN x5.presence = 'permit' THEN 'I'
			    WHEN x5.presence = 'absent' THEN 'A'
			    ELSE 'NA'
			    END AS presence
			FROM (
			  SELECT x1.date
			    , x4.nis
			    , x4.full_name
			    , IF(x4.gender = 'M', 'L', 'P') AS gender
			    , GROUP_CONCAT(DISTINCT x3.presence) AS presence
			  FROM class_meetings x1
			  LEFT JOIN course_classes x2
			    ON x1.course_class_id = x2.id
			  LEFT JOIN meeting_attendences x3
			    ON x1.id= x3.class_meeting_id
			  LEFT JOIN users x4
			    ON x3.student_id = x4.id
			  WHERE x2.academic_year_id = ?
			  AND x2.semester = ?
			  AND x2.class_group_id = ?
			  AND x1.date >= ? AND x1.date <= ?
			  GROUP BY 1,2,3,4
			) x5
			GROUP BY 1,2,3,4
			ORDER BY 2,1 ASC
		", [$academic_year_id, $semester, $class_group_id, $start_date, $end_date]);
		$data = [];
		foreach($query->result() as $row) {
			$data[] = [
				'date' => $row->date,
				'nis' => $row->nis,
				'full_name' => $row->full_name,
				'gender' => $row->gender,
				'presence' => $row->presence
			];
		}

		return $data;
	}

	/**
	 * Get Meeting Attendance Summary Report
	 * @param Integer $course_class_id
	 * @param String $start_date
	 * @param String $end_date
	 * @return Resource
	 */
	public function get_meeting_attendance_summary_report($course_class_id, $start_date, $end_date) {
		$query = $this->db->query("
			SELECT x1.id
			  , x1.date
			  , x1.start_time
			  , x1.end_time
			  , COALESCE(x1.discussion, '-') AS discussion
			  , SUM(IF(x2.presence = 'present', 1, 0)) AS H
			  , SUM(IF(x2.presence = 'sick', 1, 0)) AS S
			  , SUM(IF(x2.presence = 'permit', 1, 0)) AS I
			  , SUM(IF(x2.presence = 'absent', 1, 0)) AS A
			  , COUNT(*) AS total
			 FROM class_meetings x1
			  LEFT JOIN meeting_attendences x2
			    ON x1.id = x2.class_meeting_id
			WHERE x1.course_class_id = ?
			AND x1.date >= ? AND x1.date <= ?
			GROUP BY 1,2,3,4,5
			ORDER BY x1.date ASC
		", [_toInteger($course_class_id), $start_date, $end_date]);
		$data = [];
		foreach ($query->result() as $row) {
			$data[] = [
				'id' => $row->id,
				'date' => indo_date($row->date),
				'start_time' => $row->start_time,
				'end_time' => $row->end_time,
				'discussion' => $row->discussion,
				'H' => $row->H,
				'S' => $row->S,
				'I' => $row->I,
				'A' => $row->A,
				'total' => $row->total
			];
		}
		return $data;
	}

	/**
	 * Get Meeting Attendance Detail Report
	 * @param Integer $course_class_id
	 * @param String $start_date
	 * @param String $end_date
	 * @return Resource
	 */
	public function get_meeting_attendance_detail_report($course_class_id, $start_date, $end_date) {
		$query = $this->db->query("
			SELECT x1.id
				, x3.date
				, x2.nis
				, x2.full_name
				, CASE WHEN x1.presence = 'present' THEN 'H'
					WHEN x1.presence = 'sick' THEN 'S'
					WHEN x1.presence = 'permit' THEN 'I'
					WHEN x1.presence = 'absent' THEN 'A'
					END AS presence
			FROM meeting_attendences x1
			LEFT JOIN users x2
				ON x1.student_id = x2.id
			LEFT JOIN class_meetings x3
				ON x1.class_meeting_id = x3.id
			WHERE x3.course_class_id = ?
			AND x3.date >= ? AND x3.date <= ?
		", [_toInteger($course_class_id), $start_date, $end_date]);
		$data = [];
		foreach ($query->result() as $row) {
			$data[] = [
				'id' => $row->id,
				'date' => $row->date,
				'nis' => $row->nis,
				'full_name' => $row->full_name,
				'presence' => $row->presence
			];
		}
		return $data;
	}
}
